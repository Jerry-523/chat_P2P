const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const sqlite3 = require('sqlite3').verbose();

// Cria ou abre o banco de dados
let db = new sqlite3.Database('messages.db', err => {
    if (err) {
        console.error(err.message);
    }
    console.log('Conectado ao banco de dados messages.db');
    
    // Cria a tabela messages se ela não existir
    db.run(`CREATE TABLE IF NOT EXISTS messages (
        client_ip TEXT,
        message TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    )`, err => {
        if (err) {
            console.error(err.message);
        }
        console.log('Tabela messages criada no banco de dados messages.db');
    });
});

const server = http.createServer((req, res) => {
    let parsedUrl = url.parse(req.url, true);
    let pathname = parsedUrl.pathname;

    if (pathname === '/messages' && req.method === 'GET') {
        getMessages(res);
    } else if (pathname === '/messages' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            let message = JSON.parse(body).message;
            let clientIp = req.connection.remoteAddress;
            saveMessage(clientIp, message, res);
        });
    } else {
        let filePath = '.' + pathname;
        if (filePath === './') {
            filePath = './public/index.html';
        }
    
        fs.readFile(filePath, (err, data) => {
            if (err) {
                res.writeHead(404);
                res.end('404 - Not Found');
                return;
            }
    
            res.writeHead(200);
            res.end(data);
        });
    }
});

function saveMessage(clientIp, message, res) {
    let timestamp = new Date().toISOString().slice(0, 19).replace('T', ' ');
    db.run(`INSERT INTO messages (client_ip, message, timestamp) VALUES (?, ?, ?)`, [clientIp, message, timestamp], err => {
        if (err) {
            console.error(err.message);
            res.writeHead(500);
            res.end('500 - Internal Server Error');
            return;
        }
        console.log('Mensagem salva no banco de dados');
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end();
    });
}

function getMessages(res) {
    db.all(`SELECT * FROM messages ORDER BY timestamp`, (err, rows) => {
        if (err) {
            console.error(err.message);
            res.writeHead(500);
            res.end('500 - Internal Server Error');
            return;
        }

        let messages = rows.map(row => {
            return {
                message: row.message,
                client_ip: row.client_ip,
                timestamp: row.timestamp
            };
        });
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(messages));
    });
}

const PORT = 3000;
server.listen(PORT, '0.0.0.0', () => {
    console.log(`Servidor iniciado em http://localhost:${PORT}`);
});
