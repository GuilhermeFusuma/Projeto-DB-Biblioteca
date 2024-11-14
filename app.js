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

app.post('/', async (req, res) => {
    
});

app.post('/livros', async (req, res) => {   // Código que será rodado quando direcionado para /livros
    const {Titulo_livro, ID_Genero, ID_Autor, Volume, Edição} = req.body;   // objeto importado do body

    try {
        await sql.connect(dbConfig);
        const query = "INSERT INTO Titulos(Titulo_livro, ID_Genero, ID_Autor, Volume, Edição) VALUES (@Titulo_livro, @ID_Genero, @ID_Autor, @Volume, @Edição)"; // consulta que será realizada no SQL Server
        const request = new sql.Request();  // define as variáveis da consulta
        request.input('Titulo_livro', sql.NVarChar, Titulo_livro);
        request.input('ID_Genero', sql.Int, ID_Genero);
        request.input('ID_Autor', sql.Int, ID_Autor);
        request.input('Volume', sql.VarChar(2), Volume);
        request.input('Edição', sql.VarChar(4), Edição);
        await request.query(query); // realiza a consulta
        
        res.send('Livro Adicionado com sucesso!');  // envia uma notificação para a página do usuário
    } catch (error) {
        res.status(500).send('Erro ao adicionar produto: ' + error.message);
    }
});

app.post('/cadastro', async (req, res) => {
    const {Nome_Completo, ID_Curso, qtd_Emprestimos, Email} = req.body;

    try {
        const query = "EXEC ADD_Aluno @Nome_Completo, @ID_Curso, @Email"
        await sql.connect(dbConfig);
        const request = new sql.Request();
        request.input('Nome_Completo', sql.VarChar(100), Nome_Completo);
        request.input('ID_Curso', sql.Int, ID_Curso);
        request.input('Email', sql.VarChar(100), Email);
        await request.query(query);

        res.send('Usuário Adicionado com Sucesso!!');
    } catch (error) {
        res.status(500).send('Erro ao cadastrar: ' + error.message);
    }
});

app.listen(port, () => { //roda sempre que o código for executado no node.js
    console.log(`Servidor rodando em http://localhost:${port}`);
});