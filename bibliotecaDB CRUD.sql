DROP DATABASE BibliotecaDB
GO

CREATE DATABASE BibliotecaDB
GO

USE BibliotecaDB

CREATE TABLE Cursos(
	ID_Curso INT IDENTITY(1, 1) PRIMARY KEY,
	Nome_curso VARCHAR(100)
)
GO

CREATE TABLE Alunos(
	Email VARCHAR PRIMARY KEY,
	Nome_Completo VARCHAR(256),
	ID_Curso INT,
	qtd_Emprestimos INT
	FOREIGN KEY (ID_Curso) REFERENCES Cursos(ID_Curso)
)
GO

CREATE TABLE Categorias (
    ID_Categoria INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
)
GO

CREATE TABLE Subcategorias (
    ID_Subcategoria INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    ID_Categoria INT,
    FOREIGN KEY (ID_Categoria) REFERENCES Categorias(ID_Categoria)
);
GO

CREATE TABLE Titulos(
	ID_Titulo INT IDENTITY(1, 1) PRIMARY KEY,
	Autor VARCHAR(100),
	Volume VARCHAR,
	Edicao VARCHAR,
	Ano_Publicacao DATE,
	ID_SubCategoria INT,
	FOREIGN KEY (ID_SubCategoria) REFERENCES SubCategorias(ID_SubCategoria)
)
GO

CREATE TABLE Exemplares(
	ID_Exemplar INT IDENTITY(1, 1) PRIMARY KEY,
	Exemplar VARCHAR,
	ID_Titulo INT NOT NULL,
	Status VARCHAR
	FOREIGN KEY (ID_Titulo)	REFERENCES Titulos(ID_Titulo)
)
GO

CREATE TABLE Emprestimos(
	ID_Emprestimo INT IDENTITY(1, 1) PRIMARY KEY,
	ID_Exemplar INT NOT NULL,
	Email VARCHAR NOT NULL,
	Data_Emprestimo DATETIME DEFAULT GETDATE(),
	Data_Devolucao DATE,
	FOREIGN KEY (ID_Exemplar) REFERENCES Exemplares(ID_Exemplar),
	FOREIGN KEY (Email) REFERENCES Alunos(Email)
)
GO

CREATE TABLE Presencas(
	ID_Presenca INT IDENTITY(1, 1) PRIMARY KEY,
	ID_Curso INT NOT NULL,
	Email VARCHAR NOT NULL,
	Data_Presenca DATETIME DEFAULT GETDATE()
	FOREIGN KEY (Email) REFERENCES Alunos(Email),
	FOREIGN KEY (ID_Curso) REFERENCES Cursos(ID_Curso)
)
GO

INSERT INTO Cursos(Nome_curso)
VALUES ('DEVT')
GO

INSERT INTO Categorias (Nome)
VALUES 
('Fic��o'),
('N�o-Fic��o'),
('Ci�ncia'),
('Hist�ria'),
('Tecnologia'),
('Artes'),
('Literatura'),
('Filosofia'),
('Culin�ria'),
('Psicologia'),
('Economia'),
('Pol�tica'),
('Educa��o'),
('Sa�de'),
('Viagens');
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Biografia', 2),
('Autoajuda', 2),
('Sa�de', 2),
('Hist�rias Reais', 2);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('F�sica', 3),
('Qu�mica', 3),
('Astronomia', 3),
('Biologia', 3),
('Geologia', 3);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Hist�ria Antiga', 4),
('Hist�ria Medieval', 4),
('Hist�ria Moderna', 4),
('Hist�ria Contempor�nea', 4),
('Hist�ria da Arte', 4);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Intelig�ncia Artificial', 5),
('Desenvolvimento de Software', 5),
('Redes e Seguran�a', 5),
('Computa��o em Nuvem', 5),
('Blockchain', 5);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Pintura', 6),
('Escultura', 6),
('M�sica', 6),
('Dan�a', 6),
('Teatro', 6),
('Fotografia', 6);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Cl�ssicos', 7),
('Contos', 7),
('Poesia', 7),
('Drama', 7),
('Literatura Brasileira', 7);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('�tica', 8),
('L�gica', 8),
('Metaf�sica', 8),
('Filosofia Pol�tica', 8),
('Filosofia Contempor�nea', 8);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Cozinha Italiana', 9),
('Cozinha Francesa', 9),
('Doces e Sobremesas', 9),
('Cozinha Vegana', 9),
('Cozinha Brasileira', 9);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Psicologia Cl�nica', 10),
('Psicologia Social', 10),
('Psicologia do Desenvolvimento', 10),
('Neuropsicologia', 10);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Microeconomia', 11),
('Macroeconomia', 11),
('Economia Internacional', 11),
('Economia Ambiental', 11);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Teoria Pol�tica', 12),
('Pol�tica Internacional', 12),
('Pol�tica Brasileira', 12),
('Partidos e Elei��es', 12);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Educa��o Infantil', 13),
('Educa��o B�sica', 13),
('Ensino Superior', 13),
('Pedagogia', 13);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Medicina', 14),
('Enfermagem', 14),
('Nutri��o', 14),
('Sa�de Mental', 14),
('Sa�de P�blica', 14);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Turismo de Aventura', 15),
('Turismo Cultural', 15),
('Turismo de Lazer', 15),
('Turismo de Neg�cios', 15);
GO