-- Remover chaves estrangeiras
ALTER TABLE Presencas DROP CONSTRAINT FK__Presencas__Data___4CA06362;
ALTER TABLE Emprestimos DROP CONSTRAINT FK__Emprestim__Email__48CFD27E;

-- Remover a chave prim�ria (se a coluna Email for parte da PK)
ALTER TABLE Alunos DROP CONSTRAINT PK__Alunos__A9D10535B11A0B2E;

ALTER TABLE Alunos
ALTER COLUMN Email NVARCHAR(255) NOT NULL;

-- Recriar a chave prim�ria
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

EXEC sp_rename 'Alunos', 'Usuarios';
EXEC sp_rename 'Cursos', 'Tipo_Usuarios';

EXEC sp_rename 'Usuarios.ID_Curso', 'ID_Tipo';
EXEC sp_rename 'Tipo_Usuarios.ID_Curso', 'ID_Tipo';
EXEC sp_rename 'Cursos.Nome_curso', 'Nome';

ALTER TABLE Usuarios
DROP CONSTRAINT FK__Alunos__qtd_Empr__398D8EEE

ALTER TABLE Usuarios
ADD CONSTRAINT FK__Usuarios__Tipo_Usuarios FOREIGN KEY (ID_Tipo)
REFERENCES Tipo_Usuarios(ID_Tipo)

IF EXISTS (SELECT * 
           FROM sys.objects 
           WHERE object_id = OBJECT_ID(N'dbo.MinhaProcedure') AND type = N'P')
BEGIN
    DROP PROCEDURE dbo.ADD_Alunos;
END



SELECT *
FROM Usuarios

SELECT *
FROM Emprestimos

EXEC sp_help 'Usuarios';       -- Verifica a estrutura da tabela Usuarios
EXEC sp_help 'Tipo_Usuarios'; -- Verifica a estrutura da tabela Tipo_Usuarios