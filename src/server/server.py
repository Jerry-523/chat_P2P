from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class RequestHandler(BaseHTTPRequestHandler):
    def _set_response(self, status_code=200, headers={}):
        self.send_response(status_code)
        for key, value in headers.items():
            self.send_header(key, value)
        self.end_headers()

    def do_GET(self):
        self._set_response()
        self.wfile.write(json.dumps(messages).encode('utf-8'))

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')
        message_json = json.loads(post_data)
        message = message_json.get('message', '')
        
        self._set_response()
        self.wfile.write('Servidor: Recebi sua mensagem: {}'.format(message).encode('utf-8'))
        messages.append(message)
        print('{} ~#: {}'.format(self.client_address[0], message))

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

if __name__ == '__main__':
    port = 3000
    messages = ['olaaaaaaaaaaa']

    server_address = ('', port)
    httpd = HTTPServer(server_address, RequestHandler)
    print('Servidor iniciado em http://localhost:{}'.format(port))
    httpd.serve_forever()
