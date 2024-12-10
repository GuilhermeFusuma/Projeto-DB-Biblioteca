ALTER TABLE Alunos
ALTER COLUMN Email VARCHAR(100);



INSERT INTO Tipo_Usuarios(Nome)
VALUES
	--('Devt'),
	('Logistica'),
	('Docente'),
	('')

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

INSERT INTO Assuntos (ID_GeneroCategoria, Nome)
VALUES
(1, 'Viagens Interplanet�rias'),   -- G�nero 'Fic��o Cient�fica'
(1, 'Rob�s e Aut�matos'),          -- G�nero 'Fic��o Cient�fica'
(2, 'Mitologia e Lendas'),         -- G�nero 'Fantasia'
(2, 'Drag�es e Magia'),            -- G�nero 'Fantasia'
(3, 'Romances Policiais'),         -- G�nero 'Mist�rio'
(3, 'Casos de Assassinato'),       -- G�nero 'Mist�rio'
(4, 'Com�dias Rom�nticas'),        -- G�nero 'Romance'
(4, 'Tri�ngulos Amorosos'),        -- G�nero 'Romance'
(5, 'Terror G�tico'),              -- G�nero 'Terror'
(5, 'Criaturas Sobrenaturais'),    -- G�nero 'Terror'
(6, 'Dramas de Fam�lia'),          -- G�nero 'Drama'
(6, 'Narrativas Emocionais'),      -- G�nero 'Drama'
(7, 'Explora��o de Continentes'),  -- G�nero 'Aventura'
(7, 'Jornadas de Descoberta'),     -- G�nero 'Aventura'
(8, 'Grandes Guerras Mundiais'),   -- G�nero 'Hist�rico'
(8, 'Biografias de Reis e Rainhas'); -- G�nero 'Hist�rico'

INSERT INTO Assuntos (ID_GeneroCategoria, Nome)
VALUES
(9, 'Cl�ssicos da Literatura'),   -- Categoria 'Fic��o'
(9, 'Romances Dist�picos'),       -- Categoria 'Fic��o'
(10, 'Mem�rias e Biografias'),    -- Categoria 'N�o Fic��o'
(10, 'Relatos de Viagens'),       -- Categoria 'N�o Fic��o'
(11, 'Ci�ncia da Computa��o'),    -- Categoria 'Acad�mico'
(11, 'Engenharia El�trica'),      -- Categoria 'Acad�mico'
(12, 'Medicina Geral'),           -- Categoria 'Sa�de e Bem-Estar'
(12, 'Psicologia e Autoajuda'),   -- Categoria 'Sa�de e Bem-Estar'
(13, 'Gest�o de Projetos'),       -- Categoria 'Neg�cios e Economia'
(13, 'Planejamento Estrat�gico'), -- Categoria 'Neg�cios e Economia'
(14, 'Hist�ria da Pintura'),      -- Categoria 'Arte e Design'
(14, 'Arquitetura Cl�ssica'),     -- Categoria 'Arte e Design'
(15, 'Estudos sobre Religi�es'),  -- Categoria 'Religi�o'
(15, 'Espiritualidade e F�'),     -- Categoria 'Religi�o'
(16, 'Hist�ria do Futebol'),      -- Categoria 'Esportes'
(16, 'Guias de Treinamento');     -- Categoria 'Esportes'

SELECT *
FROM GeneroCategoria
SELECT *
FROM assuntos

SELECT * FROM Usuarios
SELECT *
FROM Tipo_Usuarios
SELECT * FROM VW_UsuariosPresenca

SELECT * FROM VW_LivrosDados