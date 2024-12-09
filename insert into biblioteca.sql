CREATE TABLE Presenca(
	ID_Presenca INT IDENTITY(1, 1) PRIMARY KEY,
	ID_Aluno INT,
	ID_Curso INT,
	Data DATETIME2 DEFAULT SYSDATETIME()
	FOREIGN KEY (ID_Aluno) REFERENCES Alunos(ID_Aluno),
	FOREIGN KEY (ID_Curso) REFERENCES Cursos(ID_Curso)
)

ALTER TABLE Alunos
ALTER COLUMN Email VARCHAR(100);

CREATE OR ALTER PROCEDURE ADD_Aluno
	@Nome_Completo VARCHAR(100),
	@ID_Curso INT,
	@Email VARCHAR(100)
AS
	INSERT INTO Alunos(Nome_Completo, ID_Curso, Email)
	VALUES
		(@Nome_Completo, @ID_Curso, @Email)

INSERT INTO Cursos(Nome_do_Curso)
VALUES
	--('Devt'),
	('Logistica'),
	('Docente'),
	('')

CREATE OR ALTER TRIGGER Atualiza_QtdEmprestimos
ON Emprestimos
AFTER INSERT
AS
BEGIN
    -- Atualiza a quantidade de empr�stimos do aluno
    UPDATE Alunos
    SET qtd_Emprestimos = qtd_Emprestimos + 1
    WHERE Email IN (SELECT Email FROM INSERTED)
END

INSERT INTO GeneroCategoria (Tipo, Nome)
VALUES
('G�nero', 'Fic��o Cient�fica'),
('G�nero', 'Fantasia'),
('G�nero', 'Mist�rio'),
('G�nero', 'Romance'),
('G�nero', 'Terror'),
('G�nero', 'Drama'),
('G�nero', 'Aventura'),
('G�nero', 'Hist�rico'),
('Categoria', 'Fic��o'),
('Categoria', 'N�o Fic��o'),
('Categoria', 'Acad�mico'),
('Categoria', 'Sa�de e Bem-Estar'),
('Categoria', 'Neg�cios e Economia'),
('Categoria', 'Arte e Design'),
('Categoria', 'Religi�o'),
('Categoria', 'Esportes');

INSERT INTO Assuntos (ID_GeneroCategoria, Nome)
VALUES
(1, 'Cyberpunk'),             -- G�nero 'Fic��o Cient�fica'
(1, 'Space Opera'),           -- G�nero 'Fic��o Cient�fica'
(2, 'Alta Fantasia'),         -- G�nero 'Fantasia'
(2, 'Fantasia �pica'),        -- G�nero 'Fantasia'
(3, 'Detetive'),              -- G�nero 'Mist�rio'
(3, 'Policial'),              -- G�nero 'Mist�rio'
(4, 'Romance Hist�rico'),     -- G�nero 'Romance'
(4, 'Romance Contempor�neo'), -- G�nero 'Romance'
(5, 'Psicol�gico'),          -- G�nero 'Terror'
(5, 'Sobrenatural'),         -- G�nero 'Terror'
(6, 'Com�dia Dram�tica'),    -- G�nero 'Drama'
(6, 'Trag�dia'),             -- G�nero 'Drama'
(7, 'Explora��o Espacial'),  -- G�nero 'Aventura'
(7, 'Viagem no Tempo'),      -- G�nero 'Aventura'
(8, 'Guerra Civil'),         -- G�nero 'Hist�rico'
(8, 'Revolu��es'),           -- G�nero 'Hist�rico'
(8, 'Monarquias e Imp�rios');-- G�nero 'Hist�rico'

-- Inserir Assuntos/Subcategorias para Categorias
INSERT INTO Assuntos (ID_GeneroCategoria, Nome)
VALUES
(9, 'Fic��o Hist�rica'),     -- Categoria 'Fic��o'
(9, 'Distopia'),             -- Categoria 'Fic��o'
(10, 'Ci�ncias Pol�ticas'),  -- Categoria 'N�o Fic��o'
(10, 'Jornalismo'),          -- Categoria 'N�o Fic��o'
(11, 'Qu�mica Org�nica'),    -- Categoria 'Acad�mico'
(11, 'C�lculo'),             -- Categoria 'Acad�mico'
(12, 'Nutri��o Esportiva'),  -- Categoria 'Sa�de e Bem-Estar'
(12, 'Sa�de Mental'),        -- Categoria 'Sa�de e Bem-Estar'
(13, 'Empreendedorismo'),    -- Categoria 'Neg�cios e Economia'
(14, 'Design de Interiores'),-- Categoria 'Arte e Design'
(15, 'Filosofia Religiosa'), -- Categoria 'Religi�o'
(15, 'Teologia'),            -- Categoria 'Religi�o'
(16, 'Futebol'),             -- Categoria 'Esportes'
(16, 'Atletismo');    


SELECT *
FROM GeneroCategoria
SELECT *
FROM assuntos

CREATE OR ALTER VIEW VW_UsuariosPresenca AS
SELECT 
	DISTINCT Nome_Completo,
	U.Email,
	T.Nome,
	COUNT(P.Email) OVER (PARTITION BY (U.Email)) AS Presencas
FROM Usuarios U
INNER JOIN Tipo_Usuarios T ON U.ID_Tipo = T.ID_Tipo 
INNER JOIN Presencas P ON U.Email = P.Email

SELECT * FROM Usuarios
SELECT *
FROM Tipo_Usuarios
SELECT * FROM VW_UsuariosPresenca

CREATE OR ALTER FUNCTION ID_exemplarPorTitulo (@Titulo_livro VARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @ID_exemplar INT -- Especificando o tipo de dado da vari�vel

    -- Atribuindo o valor de ID_Exemplar � vari�vel @ID_exemplar
    SET @ID_exemplar = (SELECT TOP 1 ID_Exemplar
                        FROM Exemplares
                        WHERE ID_Titulo = (SELECT TOP 1 ID_Titulo
                                           FROM Titulos
                                           WHERE Titulo_Livro = @Titulo_livro))

    -- Retorna o valor de ID_Exemplar
    RETURN @ID_exemplar
END

CREATE OR ALTER TRIGGER	TR_Adicionar_Exemplar
ON Titulos
AFTER INSERT
AS
BEGIN
	DECLARE @ID_Titulo INT
	SET @ID_Titulo = (SELECT ID_Titulo FROM inserted)
	INSERT INTO Exemplares(Exemplar, ID_Titulo, Status)
	VALUES (1, @ID_Titulo, 'Dispon�vel')
END

CREATE OR ALTER VIEW VW_LivrosDados AS
SELECT 
T.ID_Titulo,
Titulo_Livro,
Autor,
Volume,
Edicao,
Data_Registro,
Assunto_id,
COUNT(CASE WHEN E.Status = 'Dispon�vel' THEN 1 END) OVER (PARTITION BY T.ID_Titulo) AS qtd_Disponiveis
FROM Titulos T
INNER JOIN Exemplares E ON E.ID_Titulo = T.ID_Titulo


SELECT * FROM VW_LivrosDados