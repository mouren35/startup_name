import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startup_namer/widget/post/user_avatar.dart';


class NewPostScreen extends StatelessWidget {
  final User user;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NewPostScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新帖子'),
        actions: [
          UserAvatar(email: user.email!),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '标题'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '内容'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
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
                    'likes': [],
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('发布'),
            ),
          ],
        ),
      ),
    );
  }
}
