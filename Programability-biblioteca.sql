--procedures
CREATE OR ALTER PROCEDURE ADD_Usuario
@Email VARCHAR(100),
@Nome_Completo VARCHAR(100),
@ID_Tipo INT
AS
	INSERT INTO Usuarios(Email, Nome_Completo, ID_Tipo)
	VALUES (@Email, @Nome_Completo, @ID_Tipo)
GO

--triggers
CREATE OR ALTER TRIGGER Atualiza_QtdEmprestimos
ON Emprestimos
AFTER INSERT
AS
BEGIN
    -- Atualiza a quantidade de empréstimos do aluno
    UPDATE Usuarios
    SET qtd_Emprestimos = qtd_Emprestimos + 1
    WHERE Email IN (SELECT Email FROM INSERTED)
END

CREATE OR ALTER TRIGGER	TR_Adicionar_Exemplar
ON Titulos
AFTER INSERT
AS
BEGIN
	DECLARE @ID_Titulo INT
	SET @ID_Titulo = (SELECT ID_Titulo FROM inserted)
	INSERT INTO Exemplares(Exemplar, ID_Titulo, Status)
	VALUES (1, @ID_Titulo, 'Disponível')
END




--views
CREATE OR ALTER VIEW VW_UsuariosPresenca AS
SELECT 
	DISTINCT Nome_Completo,
	U.Email,
	T.Nome,
	COUNT(P.Email) OVER (PARTITION BY (U.Email)) AS Presencas
FROM Usuarios U
INNER JOIN Tipo_Usuarios T ON U.ID_Tipo = T.ID_Tipo 
INNER JOIN Presencas P ON U.Email = P.Email

CREATE OR ALTER VIEW VW_LivrosDados AS
SELECT 
T.ID_Titulo,
Titulo_Livro,
Autor,
Volume,
Edicao,
Data_Registro,
Assunto_id,
COUNT(CASE WHEN E.Status = 'Disponível' THEN 1 END) OVER (PARTITION BY T.ID_Titulo) AS qtd_Disponiveis
FROM Titulos T
INNER JOIN Exemplares E ON E.ID_Titulo = T.ID_Titulo

CREATE OR ALTER VIEW vw_Emprestimo_dado 
AS   
SELECT  
	FORMAT(Data_Emprestimo, 'dd/MM/yyyy') AS Data_Emprestimo,
	Data_Devolucao,
	Nome_completo,
	Titulo_Livro,
	Emprestimos.Status,
	ID_Emprestimo,
	Exemplares.ID_Exemplar
FROM Emprestimos
INNER JOIN Usuarios ON Emprestimos.Email = Usuarios.Email  
INNER JOIN Exemplares ON Exemplares.ID_Exemplar = Emprestimos.ID_Exemplar  
INNER JOIN Titulos ON Exemplares.ID_Titulo = Titulos.ID_Titulo
WHERE Emprestimos.Status != 'Devolvido'


--functions
CREATE OR ALTER FUNCTION ID_exemplarPorTitulo (@Titulo_livro VARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @ID_exemplar INT -- Especificando o tipo de dado da variável

    -- Atribuindo o valor de ID_Exemplar à variável @ID_exemplar
    SET @ID_exemplar = (SELECT TOP 1 ID_Exemplar
                        FROM Exemplares
                        WHERE ID_Titulo = (SELECT TOP 1 ID_Titulo
                                           FROM Titulos
                                           WHERE Titulo_Livro = @Titulo_livro))

    -- Retorna o valor de ID_Exemplar
    RETURN @ID_exemplar
END