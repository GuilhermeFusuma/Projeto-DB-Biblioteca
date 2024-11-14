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
    const {Nome_Completo, ID_Curso, Email} = req.body;

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

app.post('/presenca', async (req, res) => {
    const {Email} = req.body;

    try {
        await sql.connect(dbConfig);
        //Consulta que será feita para checar se o email está presente na tabela
        const result = await sql.query` 
        SELECT COUNT(*) AS Existe   
        FROM Alunos
        WHERE Email = ${Email}
        `;
        //Caso o email esteja na tabela
        if (result.recordset[0].Existe > 0) {
            //Consulta que consegue os IDs do aluno e do curso deste aluno
            const alunoData = await sql.query`
                SELECT ID_Aluno, ID_Curso
                FROM Alunos
                WHERE Email = ${Email}
            `;
        
            if (alunoData.recordset.length > 0) {
                //Salva os IDs para usar na query
                const { ID_Aluno, ID_Curso } = alunoData.recordset[0];

                // Inserção de dados na tabela Presenca
                const query = "INSERT INTO Presenca(ID_Aluno, ID_Curso) VALUES (@ID_Aluno, @ID_Curso)";
                const request = new sql.Request();
                request.input('ID_Aluno', sql.Int, ID_Aluno);
                request.input('ID_Curso', sql.Int, ID_Curso);

                // Executa o INSERT
                await request.query(query);

                res.send('Presença registrada com sucesso!');
            }
        } else { // se o email não for encontrado
            res.send('O Email não está cadastrado ou está incorreto!');
        }
    }   catch (error) {
        res.status(500).send('Erro ao marcar presença: ' + error.message + ID_Aluno + ID_Curso);
    }
});

app.listen(port, () => { //roda sempre que o código for executado no node.js
    console.log(`Servidor rodando em http://localhost:${port}`);
});