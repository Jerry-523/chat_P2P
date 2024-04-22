from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import sqlite3
from datetime import datetime

class RequestHandler(BaseHTTPRequestHandler):
    def _set_response(self, status_code=200, headers={}):
        self.send_response(status_code)
        for key, value in headers.items():
            self.send_header(key, value)
        self.end_headers()

    def do_GET(self):
        self._set_response()
        self.wfile.write(json.dumps(self.get_messages()).encode('utf-8'))

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')
        message_json = json.loads(post_data)
        message = message_json.get('message', '')

        client_ip = self.client_address[0]
        self.save_message(client_ip, message)

        self._set_response()
        response_message = 'Servidor: Recebi sua mensagem: {}'.format(message)
        self.wfile.write(response_message.encode('utf-8'))
        print('{} ~#: {}'.format(client_ip, message))

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def save_message(self, client_ip, message):
        connection = sqlite3.connect('messages.db')
        cursor = connection.cursor()
        cursor.execute('''CREATE TABLE IF NOT EXISTS messages
                          (client_ip TEXT, message TEXT, timestamp DATETIME)''')
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        cursor.execute("INSERT INTO messages VALUES (?, ?, ?)", (client_ip, message, timestamp))
        connection.commit()
        connection.close()

    def get_messages(self):
        connection = sqlite3.connect('messages.db')
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM messages ORDER BY timestamp")
        messages = [{'client_ip': row[0], 'message': row[1], 'timestamp': row[2]} for row in cursor.fetchall()]
        connection.close()
        return messages

if __name__ == '__main__':
    port = 3000
    server_address = ('', port)
    httpd = HTTPServer(server_address, RequestHandler)
    print('Servidor iniciado em http://localhost:{}'.format(port))
    httpd.serve_forever()
