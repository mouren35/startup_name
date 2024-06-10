import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewPostScreen extends StatelessWidget {
  final User user;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NewPostScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _contentController.text.isNotEmpty) {
                  await _firestore.collection('posts').add({
                    'title': _titleController.text,
                    'content': _contentController.text,
                    'userId': user.uid,
                    'email': user.email,
                    'timestamp': FieldValue.serverTimestamp(),
                    'likes': [], // Initialize likes as an empty array
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
