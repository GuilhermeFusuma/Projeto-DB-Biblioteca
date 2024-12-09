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
    -- Atualiza a quantidade de empréstimos do aluno
    UPDATE Alunos
    SET qtd_Emprestimos = qtd_Emprestimos + 1
    WHERE Email IN (SELECT Email FROM INSERTED)
END

INSERT INTO GeneroCategoria (Tipo, Nome)
VALUES
('Gênero', 'Ficção Científica'),
('Gênero', 'Fantasia'),
('Gênero', 'Mistério'),
('Gênero', 'Romance'),
('Gênero', 'Terror'),
('Gênero', 'Drama'),
('Gênero', 'Aventura'),
('Gênero', 'Histórico'),
('Categoria', 'Ficção'),
('Categoria', 'Não Ficção'),
('Categoria', 'Acadêmico'),
('Categoria', 'Saúde e Bem-Estar'),
('Categoria', 'Negócios e Economia'),
('Categoria', 'Arte e Design'),
('Categoria', 'Religião'),
('Categoria', 'Esportes');

INSERT INTO Assuntos (ID_GeneroCategoria, Nome)
VALUES
(1, 'Cyberpunk'),             -- Gênero 'Ficção Científica'
(1, 'Space Opera'),           -- Gênero 'Ficção Científica'
(2, 'Alta Fantasia'),         -- Gênero 'Fantasia'
(2, 'Fantasia Épica'),        -- Gênero 'Fantasia'
(3, 'Detetive'),              -- Gênero 'Mistério'
(3, 'Policial'),              -- Gênero 'Mistério'
(4, 'Romance Histórico'),     -- Gênero 'Romance'
(4, 'Romance Contemporâneo'), -- Gênero 'Romance'
(5, 'Psicológico'),          -- Gênero 'Terror'
(5, 'Sobrenatural'),         -- Gênero 'Terror'
(6, 'Comédia Dramática'),    -- Gênero 'Drama'
(6, 'Tragédia'),             -- Gênero 'Drama'
(7, 'Exploração Espacial'),  -- Gênero 'Aventura'
(7, 'Viagem no Tempo'),      -- Gênero 'Aventura'
(8, 'Guerra Civil'),         -- Gênero 'Histórico'
(8, 'Revoluções'),           -- Gênero 'Histórico'
(8, 'Monarquias e Impérios');-- Gênero 'Histórico'

-- Inserir Assuntos/Subcategorias para Categorias
INSERT INTO Assuntos (ID_GeneroCategoria, Nome)
VALUES
(9, 'Ficção Histórica'),     -- Categoria 'Ficção'
(9, 'Distopia'),             -- Categoria 'Ficção'
(10, 'Ciências Políticas'),  -- Categoria 'Não Ficção'
(10, 'Jornalismo'),          -- Categoria 'Não Ficção'
(11, 'Química Orgânica'),    -- Categoria 'Acadêmico'
(11, 'Cálculo'),             -- Categoria 'Acadêmico'
(12, 'Nutrição Esportiva'),  -- Categoria 'Saúde e Bem-Estar'
(12, 'Saúde Mental'),        -- Categoria 'Saúde e Bem-Estar'
(13, 'Empreendedorismo'),    -- Categoria 'Negócios e Economia'
(14, 'Design de Interiores'),-- Categoria 'Arte e Design'
(15, 'Filosofia Religiosa'), -- Categoria 'Religião'
(15, 'Teologia'),            -- Categoria 'Religião'
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


SELECT * FROM VW_LivrosDados