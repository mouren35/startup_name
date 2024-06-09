import 'package:flutter/material.dart';
import 'package:startup_namer/model/post_comment_mo.dart';


class CommentWidget extends StatelessWidget {
  final Comment comment;

  CommentWidget(this.comment);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(comment.username[0]),
      ),
      title: Text(comment.username),
      subtitle: Text(comment.content),
      trailing: Text(comment.dateTime.toLocal().toString()),
    );
  }
}
