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
    const { Titulo_livro, Autor, Volume, Edicao, Assunto} = req.body;

    // Validação dos parâmetros
    if (!Titulo_livro || !Autor || !Assunto || !Volume || !Edicao) {
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

        // Consulta para obter o ID do assunto
        const queryAssunto = `
            SELECT ID
            FROM Assuntos
            WHERE Nome = @Nome
        `;
        const requestAssunto = new sql.Request();
        requestAssunto.input('Nome', sql.NVarChar, Assunto); //salva o nome do Assunto para realizar a consulta
        const Assunto_idResult = await requestAssunto.query(queryAssunto);

        if (Assunto_idResult.recordset.length > 0) {
            const Assunto_id = Assunto_idResult.recordset[0].ID;

            // Inserir o livro
            const checkQuery = await sql.query(`SELECT * 
            FROM Titulos 
            WHERE Titulo_livro = '${Titulo_livro}' AND Autor = '${Autor}' AND Volume = '${Volume}' AND Edicao = '${Edicao}' AND Assunto_id = '${Assunto_id}'
            `);
            const checkResult = checkQuery.recordset;

            if (checkResult.length > 0) {
                res.send('Atenção! Já existe um livro com as mesmas informações armazenado. O livro não será adicionado.');
                return;
            } 
            const query = `
                INSERT INTO Titulos (Titulo_livro, Autor, Volume, Edicao, Assunto_id)
                VALUES (@Titulo_livro, @Autor, @Volume, @Edicao, @Assunto_id)
            `;
            const request = new sql.Request();
            request.input('Titulo_livro', sql.NVarChar, Titulo_livro);
            request.input('Autor', sql.NVarChar, Autor)
            request.input('Volume', sql.VarChar(2), Volume);
            request.input('Edicao', sql.VarChar(4), Edicao);
            request.input('Assunto_id', sql.Int, Assunto_id);
            await request.query(query);



            res.send('Livro adicionado com sucesso!');
        } else {
            res.status(400).send('O nome do assunto não foi encontrado.');
        }
    } catch (error) {
        console.error('Erro ao adicionar livro:', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    }
});

// Endpoint para procurar assuntos
app.post('/assuntos', async (req, res) => {
    const {searchTerm, categoria} = req.body;

    try {
        // Conectar ao banco de dados
        await sql.connect(dbConfig);

        if (categoria > 0) {
            const query = `
            SELECT Nome
            FROM Assuntos
            WHERE Nome LIKE @searchTerm AND ID_GeneroCategoria = @ID_Categoria
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
            FROM Assuntos
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

// Endpoint para adicionar Empréstimos
app.post('/emprestimos', async (req, res) => {
    const { ID_Titulo, Email, Data_Devolucao} = req.body;

    // Validação dos parâmetros
    if (!ID_Titulo || !Email || !Data_Devolucao) {
        return res.status(400).send('Todos os campos são obrigatórios.');
    }
   
    try {
        await sql.connect(dbConfig);

        // Verifica se o Email existe na tabela Usuarios
        const checkEmailResult = await sql.query(`
        SELECT COUNT(*) AS EmailExists 
        FROM Usuarios 
        WHERE Email = '${Email}'
        `);

        const emailExists = checkEmailResult.recordset[0].EmailExists;

        if (emailExists === 0) {
            return res.status(400).send('Email não registrado. Por favor, registre o usuario antes de realizar o empréstimo.');
        }

        const result = await sql.query(`SELECT ID_Exemplar, status FROM Exemplares WHERE ID_Titulo = ${ID_Titulo} AND Status = 'disponível' ORDER BY Exemplar ASC`); // Executa a consulta
        const exemplaresList = result.recordset; // Obtém os exemplares
    
        // Verifica se não há exemplares encontrados
        if (exemplaresList.length == 0) {
            return res.status(404).send('Não foi encontrado exemplares disponíveis para este livro.');
        }

        let exemplarEncontrado = false;
        let ID_Exemplar;
    
        for (let i = 0; i < exemplaresList.length; i++) {
            let exemplar = exemplaresList[i];
            if (exemplar.status === 'disponível') { // Verifica se o status é 'disponível'
                ID_Exemplar = exemplar.ID_Exemplar;
                exemplarEncontrado = true;
                break; // Sai do loop assim que encontrar o exemplar disponível
            }
        }
    
        // Se nenhum exemplar disponível for encontrado
        if (!exemplarEncontrado) {
            return res.status(404).send('Nenhum exemplar disponível encontrado.');
        }
    
        // Inserir o Empréstimo
        const query = `
        INSERT INTO Emprestimos (ID_Exemplar, Email, Data_Devolucao, Status)
        VALUES (@ID_Exemplar, @Email, @Data_Devolucao, 'Emprestado')
        `;
        const request = new sql.Request();
        request.input('ID_Exemplar', sql.Int, ID_Exemplar);
        request.input('Email', sql.NVarChar, Email);
        request.input('Data_Devolucao', sql.Date, Data_Devolucao);
        await request.query(query);

        await sql.query(`UPDATE Exemplares
            SET Status = 'Emprestado'
            WHERE ID_Exemplar = ${ID_Exemplar}`);
    
        res.send('Empréstimo realizado com sucesso!');
    } catch (error) {
        console.error('Erro ao realizar empréstimo:', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    }
});

//Endpoint para mostrar todos os empréstimos
app.get('/VerEmprestimo', async (req, res) => {
    try {
        await sql.connect(dbConfig);

        const resultado = await sql.query('SELECT * FROM vw_Emprestimo_dado');
        const lista = resultado.recordset;

        const dataAtual = new Date();

        for (let i = 0; i < lista.length; i++) {
            // Converte para objeto Date caso necessário
            const dataDevolucao = new Date(lista[i].Data_Devolucao);
            if (dataDevolucao < dataAtual) {
                const updateQuery = "UPDATE Emprestimos SET Status = 'Atrasado' WHERE ID_Emprestimo = @ID";

                const updateRequest = new sql.Request();
                updateRequest.input('ID', sql.Int, lista[i].ID_Emprestimo);
                await updateRequest.query(updateQuery);
            }
        }

        if (lista.length > 0) {
            res.json(lista);
        } else {
            res.send('Dados não encontrados');
        }
    } catch (error) {
        console.error('Erro na consulta ao banco de dados: ', error);
        res.status(500).send('Erro ao visualizar empréstimos.');
    } finally {
        await sql.close();
    }
});

// Endpoint que atualizar o status do emprestimo
app.post('/atualizarStatus', async (req, res) => {
    const { id } = req.body;

    try {
        await sql.connect(dbConfig);

        const query = `
            UPDATE Emprestimos
            SET Status = 'Devolvido'
            WHERE ID_Emprestimo = @id
        `;
        const request = new sql.Request();
        request.input('id', sql.Int, id);
        const result = await request.query(query);

        // Verifica se alguma linha foi afetada na consulta
        if (result.rowsAffected[0] > 0) {
            res.status(200).send('Status atualizado com sucesso.');
        } else {
            res.status(404).send('Empréstimo não encontrado.');
        }
    } catch (error) {
        console.error('Erro ao atualizar empréstimo:', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    }
});

// Endpoint para procurar titulos
app.get('/titulosGet', async (req, res) => {
    try {
        await sql.connect(dbConfig);

        const result = await sql.query('SELECT * FROM Titulos');
        res.json(result.recordset);
    } catch (error) {
        console.error('Erro na consulta ao banco de dados:', err);
        res.status(500).send('Erro em conseguir titulos');
    } finally {
        await sql.close();
    }
});

// Endpoint para cadastro de usuarios
app.post('/cadastro', async (req, res) => {
    const { Nome_Completo, ID_Tipo, Email } = req.body;

    if (!Nome_Completo || !ID_Tipo || !Email) {
        return res.status(400).send('Todos os campos são obrigatórios.');
    }

    try {
        const query = "EXEC ADD_Usuario @Email, @Nome_Completo, @ID_Tipo";
        await sql.connect(dbConfig);
        const request = new sql.Request();
        request.input('Nome_Completo', sql.VarChar(100), Nome_Completo);
        request.input('ID_Tipo', sql.Int, ID_Tipo);
        request.input('Email', sql.VarChar(100), Email);
        await request.query(query);

        res.send('Usuário cadastrado com sucesso!');
    } catch (error) {
        console.error('Erro ao cadastrar usuario:', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    } finally {
        await sql.close();
    }
});

// Endpoint para registrar presença
app.post('/presenca', async (req, res) => {
    const { Email } = req.body;

    if (!Email || typeof Email !== 'string' || Email.trim() === '') {
        return res.status(400).send('Email inválido ou não fornecido.');
    }

    try {
        await sql.connect(dbConfig);
        // Inserir registro de presença
        const query = "INSERT INTO Presencas (Email) VALUES (@Email)";
        const request = new sql.Request();
        request.input('Email', sql.VarChar(255), Email);
        await request.query(query);

        res.send('Presença registrada com sucesso!');
    } catch (error) {
        console.error('Erro ao registrar presença:', error);
        res.status(500).send('Erro interno no servidor. Tente novamente mais tarde.');
    } finally {
        await sql.close();
    }
});

app.get('/verPresenca', async (req, res) => {
    try {
        await sql.connect(dbConfig);

        const result = await sql.query('SELECT * FROM VW_UsuariosPresenca');

        if (result.recordset.length > 0) {
            res.json(result.recordset);
        } else {
            res.send('Usuarios não encontrados');
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Erro Ao encontrar usuarios');
    } finally {
        await sql.close();
    }
});

app.post('/pesquisaLivro', async (req, res) => {

});

app.get('/mostrarLivros', async (req, res) => {
    try {
        await sql.connect(dbConfig);

        const query = 'SELECT * FROM VW_LivrosDados';
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


// Exemplo de requisição para Google Books API
// const fetchISBN = async (titulo) => {
//     const response = await fetch(`https://www.googleapis.com/books/v1/volumes?q=intitle:${titulo}`);
//     const data = await response.json();
  
//     if (data.items) {
//       const isbn = data.items[0].volumeInfo.industryIdentifiers.find(identifier => identifier.type === "ISBN_13")?.identifier;
//       console.log("ISBN encontrado:", isbn);
//       return isbn;
//     } else {
//       console.log("ISBN não encontrado.");
//     }
//   };