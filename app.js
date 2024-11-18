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

// Endpoint inicial (reserva para uso futuro)
app.post('/', async (req, res) => {
    res.send('Endpoint inicial pronto para uso.');
});

// Endpoint para adicionar livros
app.post('/livros', async (req, res) => {
    const { Titulo_livro, ID_Genero, ID_Autor, Volume, Edicao } = req.body;

    // Validação dos parâmetros
    if (!Titulo_livro || !ID_Genero || !ID_Autor || !Volume || !Edicao) {
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
        const query = `
            INSERT INTO Titulos (Titulo_livro, ID_Genero, ID_Autor, Volume, Edicao)
            VALUES (@Titulo_livro, @ID_Genero, @ID_Autor, @Volume, @Edicao)
        `;
        const request = new sql.Request();
        request.input('Titulo_livro', sql.NVarChar, Titulo_livro);
        request.input('ID_Genero', sql.Int, ID_Genero);
        request.input('ID_Autor', sql.Int, ID_Autor);
        request.input('Volume', sql.VarChar(2), Volume);
        request.input('Edicao', sql.VarChar(4), Edicao);
        await request.query(query);

        res.send('Livro adicionado com sucesso!');
    } catch (error) {
        console.error('Erro ao adicionar livro:', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    } finally {
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
        const query = "EXEC ADD_Aluno @Nome_Completo, @ID_Curso, @Email";
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

// Inicialização do servidor
app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});
