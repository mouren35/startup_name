class Comment {
  String id;
  String postId;
  String username;
  DateTime dateTime;
  String content;

  Comment({
    required this.id,
    required this.postId,
    required this.username,
    required this.dateTime,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'username': username,
      'dateTime': dateTime.toIso8601String(),
      'content': content,
    };
  }
}
