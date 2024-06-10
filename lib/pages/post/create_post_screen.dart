import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/post_mo.dart';
import 'package:startup_namer/provider/post_provider.dart';

class CreatePostScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content1'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newPost = Post(
                  id: DateTime.now().toString(),
                  avatarUrl: 'https://example.com/avatar.png',
                  username: 'User',
                  dateTime: DateTime.now(),
                  title: _titleController.text,
                  content: _contentController.text,
                );
                postProvider.addPost(newPost);
                Navigator.of(context).pop();
              },
              child: const Text('Post1'),
            ),
          ],
        ),
      ),
    );
  }
}
