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
('Ficção'),
('Não-Ficção'),
('Ciência'),
('História'),
('Tecnologia'),
('Artes'),
('Literatura'),
('Filosofia'),
('Culinária'),
('Psicologia'),
('Economia'),
('Política'),
('Educação'),
('Saúde'),
('Viagens');
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Biografia', 2),
('Autoajuda', 2),
('Saúde', 2),
('Histórias Reais', 2);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Física', 3),
('Química', 3),
('Astronomia', 3),
('Biologia', 3),
('Geologia', 3);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('História Antiga', 4),
('História Medieval', 4),
('História Moderna', 4),
('História Contemporânea', 4),
('História da Arte', 4);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Inteligência Artificial', 5),
('Desenvolvimento de Software', 5),
('Redes e Segurança', 5),
('Computação em Nuvem', 5),
('Blockchain', 5);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Pintura', 6),
('Escultura', 6),
('Música', 6),
('Dança', 6),
('Teatro', 6),
('Fotografia', 6);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Clássicos', 7),
('Contos', 7),
('Poesia', 7),
('Drama', 7),
('Literatura Brasileira', 7);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Ética', 8),
('Lógica', 8),
('Metafísica', 8),
('Filosofia Política', 8),
('Filosofia Contemporânea', 8);
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
('Psicologia Clínica', 10),
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
('Teoria Política', 12),
('Política Internacional', 12),
('Política Brasileira', 12),
('Partidos e Eleições', 12);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Educação Infantil', 13),
('Educação Básica', 13),
('Ensino Superior', 13),
('Pedagogia', 13);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Medicina', 14),
('Enfermagem', 14),
('Nutrição', 14),
('Saúde Mental', 14),
('Saúde Pública', 14);
GO

INSERT INTO Subcategorias (Nome, ID_Categoria)
VALUES 
('Turismo de Aventura', 15),
('Turismo Cultural', 15),
('Turismo de Lazer', 15),
('Turismo de Negócios', 15);
GO