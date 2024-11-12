const express = require('express');
const sql = require('mssql');
const cors = require('cors');
const app = express();
const port = 3000;

const dbConfig = {
    user: '',
    password: '',
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

app.get('/livros', (req, res) => {
    res.sendFile(__dirname + '/public/livros/teste.html');

    const {}
})

app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});