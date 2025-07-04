import "package:startup_namer/core/constants.dart";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final User user;

  const EditPostScreen({super.key, required this.postId, required this.user});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  void _loadPostData() async {
    DocumentSnapshot postSnapshot =
        await _firestore.collection('posts').doc(widget.postId).get();
    setState(() {
      _titleController.text = postSnapshot['title'];
      _contentController.text = postSnapshot['content'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑帖子'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '标题',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '内容',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('保存'),
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _contentController.text.isNotEmpty) {
                  try {
                    await _firestore
                        .collection('posts')
                        .doc(widget.postId)
                        .update({
                      'title': _titleController.text,
                      'content': _contentController.text,
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('更新帖子失败: $e')), // 错误提示
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
