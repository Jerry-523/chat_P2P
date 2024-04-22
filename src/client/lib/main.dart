import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(ClientApp());
}

class ClientApp extends StatefulWidget {
  @override
  _ClientAppState createState() => _ClientAppState();
}

class _ClientAppState extends State<ClientApp> {
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    getMessages();
    Timer.periodic(Duration(seconds: 5), (timer) {
      getMessages();
    });
  }

  void sendMessage() async {
    var message = _messageController.text;
    var url = Uri.parse('http://localhost:3000/messages');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"message": message}),
    );
    if (response.statusCode == 200) {
      getMessages();
      _messageController.clear();
    }
  }

  void getMessages() async {
    var url = Uri.parse('http://localhost:3000/messages');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _messages = List<String>.from(json.decode(response.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chat P2P'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _messages.map((message) {
                      return MessageWidget(message: message);
                    }).toList(),
                  ),
                ),
              ),
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Digite sua mensagem...',
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: sendMessage,
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String message;

  MessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text(
            'Resposta do servidor',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
