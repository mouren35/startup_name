import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/post_comment_mo.dart';
import 'package:startup_namer/model/post_mo.dart';
import 'package:startup_namer/provider/post_provider.dart';
import 'package:startup_namer/widget/post/comment_widget.dart';

class PostScreen extends StatelessWidget {
  final Post post;

  PostScreen(this.post);

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Text(post.username[0].toUpperCase()),
                  ),
                  title: Text(post.username),
                  subtitle: Text(post.dateTime.toLocal().toString()),
                ),
                SizedBox(height: 10),
                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(post.content),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        onPressed: () {
                          Provider.of<PostProvider>(context, listen: false)
                              .toggleLike(post.id);
                        },
                      ),
                      Text(post.likes.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: post.comments.length,
              itemBuilder: (ctx, index) {
                return CommentWidget(post.comments[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(labelText: 'Add a comment'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final newComment = Comment(
                      id: DateTime.now().toString(),
                      postId: post.id,
                      username: 'User',
                      dateTime: DateTime.now(),
                      content: _commentController.text,
                    );
                    Provider.of<PostProvider>(context, listen: false)
                        .addComment(post.id, newComment);
                    _commentController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
