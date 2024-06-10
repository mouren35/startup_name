import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/post_mo.dart';
import 'package:startup_namer/pages/post/post_detail.dart';
import 'package:startup_namer/provider/post_provider.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostScreen(post),
          ),
        );
      },
      onLongPress: () {
        _showDeleteDialog(context);
      },
      child: Card(
        margin: const EdgeInsets.all(10),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(post.content),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {
                    Provider.of<PostProvider>(context, listen: false)
                        .toggleLike(post.id);
                  },
                ),
                Text(post.likes.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<PostProvider>(context, listen: false)
                  .deletePost(post.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
