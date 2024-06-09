import 'package:startup_namer/model/post_comment_mo.dart';


class Post {
  String id;
  String username;
  DateTime dateTime;
  String title;
  String content;
  int likes;
  List<Comment> comments;

  Post({
    required this.id,
    required this.username,
    required this.dateTime,
    required this.title,
    required this.content,
    this.likes = 0,
    List<Comment>? comments, required String avatarUrl,
  }) : comments = comments ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'dateTime': dateTime.toIso8601String(),
      'title': title,
      'content': content,
      'likes': likes,
    };
  }
}
