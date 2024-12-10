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

INSERT INTO Assuntos (ID_GeneroCategoria, Nome)
VALUES
(1, 'Viagens Interplanetárias'),   -- Gênero 'Ficção Científica'
(1, 'Robôs e Autômatos'),          -- Gênero 'Ficção Científica'
(2, 'Mitologia e Lendas'),         -- Gênero 'Fantasia'
(2, 'Dragões e Magia'),            -- Gênero 'Fantasia'
(3, 'Romances Policiais'),         -- Gênero 'Mistério'
(3, 'Casos de Assassinato'),       -- Gênero 'Mistério'
(4, 'Comédias Românticas'),        -- Gênero 'Romance'
(4, 'Triângulos Amorosos'),        -- Gênero 'Romance'
(5, 'Terror Gótico'),              -- Gênero 'Terror'
(5, 'Criaturas Sobrenaturais'),    -- Gênero 'Terror'
(6, 'Dramas de Família'),          -- Gênero 'Drama'
(6, 'Narrativas Emocionais'),      -- Gênero 'Drama'
(7, 'Exploração de Continentes'),  -- Gênero 'Aventura'
(7, 'Jornadas de Descoberta'),     -- Gênero 'Aventura'
(8, 'Grandes Guerras Mundiais'),   -- Gênero 'Histórico'
(8, 'Biografias de Reis e Rainhas'); -- Gênero 'Histórico'

INSERT INTO Assuntos (ID_GeneroCategoria, Nome)
VALUES
(9, 'Clássicos da Literatura'),   -- Categoria 'Ficção'
(9, 'Romances Distópicos'),       -- Categoria 'Ficção'
(10, 'Memórias e Biografias'),    -- Categoria 'Não Ficção'
(10, 'Relatos de Viagens'),       -- Categoria 'Não Ficção'
(11, 'Ciência da Computação'),    -- Categoria 'Acadêmico'
(11, 'Engenharia Elétrica'),      -- Categoria 'Acadêmico'
(12, 'Medicina Geral'),           -- Categoria 'Saúde e Bem-Estar'
(12, 'Psicologia e Autoajuda'),   -- Categoria 'Saúde e Bem-Estar'
(13, 'Gestão de Projetos'),       -- Categoria 'Negócios e Economia'
(13, 'Planejamento Estratégico'), -- Categoria 'Negócios e Economia'
(14, 'História da Pintura'),      -- Categoria 'Arte e Design'
(14, 'Arquitetura Clássica'),     -- Categoria 'Arte e Design'
(15, 'Estudos sobre Religiões'),  -- Categoria 'Religião'
(15, 'Espiritualidade e Fé'),     -- Categoria 'Religião'
(16, 'História do Futebol'),      -- Categoria 'Esportes'
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