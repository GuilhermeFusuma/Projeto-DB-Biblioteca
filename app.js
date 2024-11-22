const express = require('express');
const sql = require('mssql');
const cors = require('cors');
const app = express();
const port = 3000;

const dbConfig = {  //objeto JSON que contém as informações para fazer login no SQL Server
    user: 'appLogin',
    password: 'SenhaBiblioteca69',
    server: '127.0.0.1',
    database: 'BibliotecaDB',
    options: {
        encrypt: true,
        trustServerCertificate: true
    }  
};

app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Endpoint para adicionar livros
app.post('/livros', async (req, res) => {
    const { Titulo_livro, Autor, Volume, Edicao, Nome} = req.body;

    // Validação dos parâmetros
    if (!Titulo_livro || !Autor || !Nome || !Volume || !Edicao) {
        console.log(Titulo_livro, Autor, Nome, Volume, Edicao)
        return res.status(400).send('Todos os campos são obrigatórios.');
    }
    if (typeof Volume !== 'string' || Volume.length > 2) {
        return res.status(400).send('Volume deve ser uma string com no máximo 2 caracteres.');
    }
    if (typeof Edicao !== 'string' || Edicao.length > 4) {
        return res.status(400).send('Edição deve ser uma string com no máximo 4 caracteres.');
    }

    try {
        await sql.connect(dbConfig);

        // Consulta para obter o ID da subcategoria
        const querySubcategoria = `
            SELECT ID_Subcategoria
            FROM Subcategorias
            WHERE Nome = @Nome
        `;
        const requestSubcategoria = new sql.Request();
        requestSubcategoria.input('Nome', sql.NVarChar, Nome); //salva o nome da subcategoria para realizar a consulta
        const ID_SubCategoria = await requestSubcategoria.query(querySubcategoria);

        if (ID_SubCategoria.recordset.length > 0) {
            const ID_SubCategoriaValue = ID_SubCategoria.recordset[0].ID_Subcategoria;

            // Inserir o livro
            const query = `
                INSERT INTO Titulos (Titulo_livro, Autor, Volume, Edicao, ID_SubCategoria)
                VALUES (@Titulo_livro, @Autor, @Volume, @Edicao, @ID_SubCategoria)
            `;
            const request = new sql.Request();
            request.input('Titulo_livro', sql.NVarChar, Titulo_livro);
            request.input('Autor', sql.NVarChar, Autor)
            request.input('Volume', sql.VarChar(2), Volume);
            request.input('Edicao', sql.VarChar(4), Edicao);
            request.input('ID_SubCategoria', sql.Int, ID_SubCategoriaValue);
            await request.query(query);

            res.send('Livro adicionado com sucesso!');
        } else {
            res.status(400).send('O nome da subcategoria não foi encontrado.');
        }
    } catch (error) {
        console.error('Erro ao adicionar livro:', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    }
});

// Endpoint para procurar subcategorias
app.post('/subcategorias', async (req, res) => {
    const {searchTerm, categoria} = req.body;

    try {
        // Conectar ao banco de dados
        await sql.connect(dbConfig);

        if (categoria > 0) {
            const query = `
            SELECT Nome
            FROM Subcategorias
            WHERE Nome LIKE @searchTerm AND ID_Categoria = @ID_Categoria
            `;

            const request = new sql.Request();
            request.input('searchTerm', sql.NVarChar, `%${searchTerm}%`);
            request.input('ID_Categoria', sql.Int, categoria);
            const result = await request.query(query);
            // Retornar os resultados encontrados
            res.json(result.recordset); 
        } else {
            const query = `
            SELECT Nome
            FROM Subcategorias
            WHERE Nome LIKE @searchTerm
            `;

            const request = new sql.Request();
            request.input('searchTerm', sql.NVarChar, `%${searchTerm}%`);
            const result = await request.query(query);
            // Retornar os resultados encontrados
            res.json(result.recordset);
        }
    
      } catch (err) {
        console.error('Erro na consulta ao banco de dados:', err);
        res.status(500).send('Erro no servidor');
      } finally {
        // Fechar a conexão com o banco
        await sql.close();
      }
});

// Endpoint para cadastro de alunos
app.post('/cadastro', async (req, res) => {
    const { Nome_Completo, ID_Curso, Email } = req.body;

    if (!Nome_Completo || !ID_Curso || !Email) {
        return res.status(400).send('Todos os campos são obrigatórios.');
    }

    try {
        const query = "EXEC ADD_Alunos @Email, @Nome_Completo, @ID_Curso";
        await sql.connect(dbConfig);
        const request = new sql.Request();
        request.input('Nome_Completo', sql.VarChar(100), Nome_Completo);
        request.input('ID_Curso', sql.Int, ID_Curso);
        request.input('Email', sql.VarChar(100), Email);
        await request.query(query);

        res.send('Usuário cadastrado com sucesso!');
    } catch (error) {
        console.error('Erro ao cadastrar aluno:', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    } finally {
        await sql.close();
    }
});

// Endpoint para registrar presença
app.post('/presenca', async (req, res) => {
    const { Email } = req.body;

    if (!Email || typeof Email !== 'string' || Email.trim() === '') {
        console.log(Email);
        return res.status(400).send('Email inválido ou não fornecido.');
    }

    try {
        await sql.connect(dbConfig);

        // Consulta para buscar informações do aluno
        const alunoQuery = `
            SELECT ID_Aluno, ID_Curso
            FROM Alunos
            WHERE Email = @Email
        `;
        const alunoRequest = new sql.Request();
        alunoRequest.input('Email', sql.VarChar(100), Email);
        const alunoData = await alunoRequest.query(alunoQuery);

        if (alunoData.recordset.length === 0) {
            return res.status(404).send('Email não encontrado no cadastro.');
        }

        const { ID_Aluno, ID_Curso } = alunoData.recordset[0];

        // Inserir registro de presença
        const query = "INSERT INTO Presenca (ID_Aluno, ID_Curso) VALUES (@ID_Aluno, @ID_Curso)";
        const request = new sql.Request();
        request.input('ID_Aluno', sql.Int, ID_Aluno);
        request.input('ID_Curso', sql.Int, ID_Curso);
        await request.query(query);

        res.send('Presença registrada com sucesso!');
    } catch (error) {
        console.error('Erro ao registrar presença:', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    } finally {
        await sql.close();
    }
});

app.post('/pesquisaLivro', async (req, res) => {
    
});

app.get('/mostrarLivros', async (req, res) => {
    try {
        await sql.connect(dbConfig);

        const query = 'SELECT * FROM Titulos';
        const result = await sql.query(query);

        res.json(result.recordset);  // Envie a resposta no formato JSON
        console.log(result.recordset);
    } catch (error) {
        console.error('Erro ao conseguir livros: ', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    } finally {
        await sql.close();
    }
});

// Inicialização do servidor
app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});
