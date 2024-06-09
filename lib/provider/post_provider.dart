import 'package:flutter/material.dart';
import 'package:startup_namer/db/post_db.dart';
import 'package:startup_namer/model/post_comment_mo.dart';
import 'package:startup_namer/model/post_mo.dart';


class PostProvider with ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    _posts = await DatabaseHelper().getPosts();
    notifyListeners();
  }

  void addPost(Post post) async {
    await DatabaseHelper().insertPost(post);
    _posts.add(post);
    notifyListeners();
  }

  void toggleLike(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      post.likes = post.likes + 1;
      DatabaseHelper().updateLikes(postId, post.likes);
      notifyListeners();
    }
  }

  void addComment(String postId, Comment comment) async {
    await DatabaseHelper().insertComment(comment);
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _posts[postIndex].comments.add(comment);
      notifyListeners();
    }
  }

  void deletePost(String postId) async {
    await DatabaseHelper().deletePost(postId);
    _posts.removeWhere((post) => post.id == postId);
    notifyListeners();
  }
}
