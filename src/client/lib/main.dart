import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController = TextEditingController();
  List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat P2P'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_messages[index], style: TextStyle(color: Colors.white),),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Digite sua mensagem... ',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textController.text);
                    setState(() {
                      _textController.text = '';
                      _fetchMessages();
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 5,)
        ],
      ),
    );
  }

  void _fetchMessages() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:3000'));
    if (response.statusCode == 200) {
      setState(() {
        _messages = List.from(response.body.split('\n'));
      });
    } else {
      print('Falha ao buscar mensagens do servidor: ${response.statusCode}');
    }
    if (_messages.isEmpty) {
      setState(() {
        _messages.add('Empty');
      });
    }
  }

  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      final url = Uri.parse('http://localhost:3000');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'message': message});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        setState(() {
          _messages.insert(0, message);
          _messages.insert(0, 'Resposta do servidor: ${response.body}');
        });
      } else {
        print('Erro ao enviar mensagem: ${response.reasonPhrase}');
      }
    }
  }
}
