import 'package:flutter/foundation.dart';
import 'package:startup_namer/db/post_db.dart';
import 'package:startup_namer/model/post_comment_mo.dart';
import 'package:startup_namer/model/post_mo.dart';


class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  PostProvider() {
    _fetchPosts();
  }

  List<Post> get posts => _posts;

  Future<void> _fetchPosts() async {
    _posts = await _dbHelper.getPosts();
    notifyListeners();
  }

  Future<void> addPost(Post post) async {
    await _dbHelper.insertPost(post);
    _posts.add(post);
    notifyListeners();
  }

  Future<void> addComment(String postId, Comment comment) async {
    await _dbHelper.insertComment(comment);
    final post = _posts.firstWhere((post) => postId == post.id);
    post.comments.add(comment);
    notifyListeners();
  }

  Future<void> toggleLike(String postId) async {
    final post = _posts.firstWhere((post) => postId == post.id);
    post.likes += 1;
    await _dbHelper.updateLikes(postId, post.likes);
    notifyListeners();
  }
}
