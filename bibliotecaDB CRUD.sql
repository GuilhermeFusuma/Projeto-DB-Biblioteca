DROP DATABASE BibliotecaDB
GO

CREATE DATABASE BibliotecaDB
GO

USE BibliotecaDB

-- Primeiro, conecte-se ao banco de dados principal
USE master;
GO

-- Crie o login do SQL Server com uma senha
CREATE LOGIN appLogin
WITH PASSWORD = 'SenhaBiblioteca69';
GO

-- Crie um usuário no banco de dados específico e associe ao login
USE BibliotecaDB;
GO

CREATE USER appLogin
FOR LOGIN appLogin;
GO

-- Atribua ao usuário a função db_owner, que concede permissões amplas no banco de dados
ALTER ROLE db_owner ADD MEMBER appLogin;
GO

-- Opcional: conceda permissões de servidor adicionais para acesso total ao SQL Server
USE master;
GO

ALTER SERVER ROLE sysadmin ADD MEMBER appLogin;
GO

CREATE TABLE Cursos(
	ID_Curso INT IDENTITY(1, 1) PRIMARY KEY,
	Nome_curso VARCHAR(100)
)
GO

CREATE TABLE Usuarios(
	Email VARCHAR PRIMARY KEY,
	Nome_Completo VARCHAR(256),
	ID_Tipo INT,
	qtd_Emprestimos INT
	FOREIGN KEY (ID_Tipo) REFERENCES Tipo_Usuarios(ID_Tipo)
)
GO

--CREATE TABLE Categorias (
--    ID_Categoria INT IDENTITY(1,1) PRIMARY KEY,
--    Nome VARCHAR(100) NOT NULL
--)
--GO

--CREATE TABLE Subcategorias (
--    ID_Subcategoria INT IDENTITY(1,1) PRIMARY KEY,
--    Nome VARCHAR(100) NOT NULL,
--    ID_Categoria INT,
--    FOREIGN KEY (ID_Categoria) REFERENCES Categorias(ID_Categoria)
--);
--GO

CREATE TABLE GeneroCategoria (
    ID INT PRIMARY KEY IDENTITY(1,1),  -- Identificador único
    Tipo VARCHAR(50),                   -- 'Gênero' ou 'Categoria'
    Nome VARCHAR(100) NOT NULL          -- Nome do gênero ou categoria (ex.: 'Ficção', 'Romance', etc.)
);
GO

CREATE TABLE Assuntos (
    ID INT PRIMARY KEY IDENTITY(1,1),  -- Identificador único do assunto
    ID_GeneroCategoria INT,             -- Chave estrangeira que referencia Gênero ou Categoria
    Nome VARCHAR(100) NOT NULL,         -- Nome do assunto ou subcategoria (ex.: 'Romance', 'História', etc.)
    FOREIGN KEY (ID_GeneroCategoria) REFERENCES GeneroCategoria(ID)  -- Relacionamento com a tabela de Gêneros e Categorias
);


CREATE TABLE Titulos(
	ID_Titulo INT IDENTITY(1, 1) PRIMARY KEY,
	Autor VARCHAR(100),
	Volume VARCHAR,
	Edicao VARCHAR,
	ID_Assunto INT,
	Data_Registro DATETIME DEFAULT GETDATE()
	FOREIGN KEY (ID_Assunto) REFERENCES Assuntos(ID)
)
GO

CREATE TABLE Exemplares(
	ID_Exemplar INT IDENTITY(1, 1) PRIMARY KEY,
	Exemplar VARCHAR,
	ID_Titulo INT NOT NULL,
	Status VARCHAR(100)
	FOREIGN KEY (ID_Titulo)	REFERENCES Titulos(ID_Titulo)
)
GO

CREATE TABLE Emprestimos(
	ID_Emprestimo INT IDENTITY(1, 1) PRIMARY KEY,
	ID_Exemplar INT NOT NULL,
	Email VARCHAR NOT NULL,
	Data_Emprestimo DATETIME DEFAULT GETDATE(),
	Data_Devolucao DATE,
	Status VARCHAR(100)
	FOREIGN KEY (ID_Exemplar) REFERENCES Exemplares(ID_Exemplar),
	FOREIGN KEY (Email) REFERENCES Usuarios(Email)
)
GO

CREATE TABLE Presencas(
	ID_Presenca INT IDENTITY(1, 1) PRIMARY KEY,
	ID_Tipo INT NOT NULL,
	Email VARCHAR NOT NULL,
	Data_Presenca DATETIME DEFAULT GETDATE()
	FOREIGN KEY (Email) REFERENCES Usuarios(Email),
	FOREIGN KEY (ID_Tipo) REFERENCES Tipo_Usuarios(ID_Tipo)
)
GO

INSERT INTO Cursos(Nome_curso)
VALUES ('DEVT')
GO

CREATE OR ALTER PROCEDURE ADD_Alunos
@Email VARCHAR(100),
@Nome_Completo VARCHAR(100),
@ID_Curso INT
AS
	INSERT INTO Alunos(Email, Nome_Completo, ID_Curso)
	VALUES (@Email, @Nome_Completo, @ID_Curso)

DELETE FROM clientes
WHERE id = 1;

ALTER TABLE Subcategorias DROP CONSTRAINT FK__Subcatego__ID_Ca__3E52440B
DROP TABLE Subcategorias
ALTER TABLE Titulos DROP CONSTRAINT [FK__Titulos__ID_SubC__412EB0B6]
ALTER TABLE Titulos DROP COLUMN ID_SubCategoria
DROP TABLE Categorias

