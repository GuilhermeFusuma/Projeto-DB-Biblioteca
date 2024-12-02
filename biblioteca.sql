-- Remover chaves estrangeiras
ALTER TABLE Presencas DROP CONSTRAINT FK__Presencas__Data___4CA06362;
ALTER TABLE Emprestimos DROP CONSTRAINT FK__Emprestim__Email__48CFD27E;

-- Remover a chave primária (se a coluna Email for parte da PK)
ALTER TABLE Alunos DROP CONSTRAINT PK__Alunos__A9D10535B11A0B2E;

ALTER TABLE Alunos
ALTER COLUMN Email NVARCHAR(255) NOT NULL;

-- Recriar a chave primária
ALTER TABLE Alunos ADD CONSTRAINT PK__Alunos__A9D10535B11A0B2E PRIMARY KEY (Email);

ALTER TABLE Presencas
ALTER COLUMN Email NVARCHAR(255) NOT NULL
ALTER TABLE Emprestimos
ALTER COLUMN Email NVARCHAR(255) NOT NULL

-- Recriar as chaves estrangeiras
ALTER TABLE Presencas ADD CONSTRAINT FK__Presencas__Email___4CA06362 FOREIGN KEY (Email) REFERENCES Alunos(Email);
ALTER TABLE Emprestimos ADD CONSTRAINT FK__Emprestim__Email__48CFD27E FOREIGN KEY (Email) REFERENCES Alunos(Email);


ALTER TABLE SubCategorias 
ADD CONSTRAINT FK_SubCategorias_GeneroCategoria
FOREIGN KEY (ID_Categoria) REFERENCES GeneroCategoria(ID)

