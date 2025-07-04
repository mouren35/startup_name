import "package:startup_namer/core/constants.dart";
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:startup_namer/utils/api_util.dart';

class WenxinChatPage extends StatefulWidget {
  const WenxinChatPage({super.key});

  @override
  _WenxinChatPageState createState() => _WenxinChatPageState();
}

class _WenxinChatPageState extends State<WenxinChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? messagesString = prefs.getString('messages');
    if (messagesString != null) {
      List<dynamic> decoded = jsonDecode(messagesString);
      setState(() {
        _messages =
            decoded.map((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String messagesString = jsonEncode(_messages);
    await prefs.setString('messages', messagesString);
  }

  void _sendMessage() async {
    final message = _controller.text;
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'role': 'user', 'content': message});
        _isLoading = true;
      });
      _controller.clear();
      await _saveMessages();
      try {
        final response = await _apiService.getWenxinResponse(message);
        if (mounted) {
          setState(() {
            _messages.add({'role': 'ai', 'content': response});
            _isLoading = false;
          });
          await _saveMessages();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _messages.add({'role': 'error', 'content': 'Error: $e'});
            _isLoading = false;
          });
          await _saveMessages();
        }
      }
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message['role'] == 'user';
    bool isError = message['role'] == 'error';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser)
          CircleAvatar(
            backgroundColor: Colors.green[100],
            child: const Text('A'),
          ),
        if (!isUser) const SizedBox(width: 8),
        Flexible(
          child: Card(
            color: isUser
                ? Colors.blue[100]
                : isError
                    ? Colors.red[100]
                    : Colors.green[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                message['content']!,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        if (isUser) const SizedBox(width: 8),
        if (isUser)
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.person),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(kPadding),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green[100],
                        child: const Text('A'),
                      ),
                      const SizedBox(width: 8),
                      const CircularProgressIndicator(),
                    ],
                  );
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: '输入您的问题',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text('发送'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
