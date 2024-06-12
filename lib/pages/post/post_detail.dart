import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:startup_namer/pages/post/edit_post_page.dart';
import 'package:startup_namer/widget/post/user_avatar.dart'; // For date formatting


class PostDetailScreen extends StatelessWidget {
  final String postId;
  final User user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _commentController = TextEditingController();

  PostDetailScreen({required this.postId, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('帖子详情'),
        actions: [
          StreamBuilder(
            stream: _firestore.collection('posts').doc(postId).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data!['userId'] == user.uid) {
                return Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditPostScreen(postId: postId, user: user),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        try {
                          await _firestore
                              .collection('posts')
                              .doc(postId)
                              .delete();
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('删除帖子失败: $e')), // 错误提示
                          );
                        }
                      },
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('posts').doc(postId).snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('加载帖子详情时出错: ${snapshot.error}')); // 错误提示
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var post = snapshot.data!;
                bool isLiked = post['likes'].contains(user.uid);
                int likesCount = post['likes'].length;
                Timestamp? timestamp = post['timestamp'];
                String formattedTime = timestamp != null
                    ? DateFormat('yyyy-MM-dd – kk:mm')
                        .format(timestamp.toDate())
                    : '无日期信息';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: UserAvatar(
                          email: post['email'],
                          radius: 20,
                          fontSize: 16), // 改小头像和字体
                      title: Text(
                        post['title'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold), // 改小字体
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post['content'],
                              style: TextStyle(fontSize: 16)), // 改小字体
                          Text(formattedTime),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                              color: isLiked ? Colors.blue : null,
                            ),
                            onPressed: () async {
                              try {
                                if (isLiked) {
                                  await _firestore
                                      .collection('posts')
                                      .doc(postId)
                                      .update({
                                    'likes': FieldValue.arrayRemove([user.uid])
                                  });
                                } else {
                                  await _firestore
                                      .collection('posts')
                                      .doc(postId)
                                      .update({
                                    'likes': FieldValue.arrayUnion([user.uid])
                                  });
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('更新点赞失败: $e')), // 错误提示
                                );
                              }
                            },
                          ),
                          Text(likesCount.toString()),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '评论',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: _firestore
                            .collection('posts')
                            .doc(postId)
                            .collection('comments')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child:
                                    Text('加载评论时出错: ${snapshot.error}')); // 错误提示
                          }
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView(
                            children: snapshot.data!.docs.map((doc) {
                              bool isLiked = doc['likes'].contains(user.uid);
                              int likesCount = doc['likes'].length;
                              Timestamp? timestamp = doc['timestamp'];
                              String formattedTime = timestamp != null
                                  ? DateFormat('yyyy-MM-dd – kk:mm')
                                      .format(timestamp.toDate())
                                  : '无日期信息';

                              return ListTile(
                                leading: UserAvatar(
                                    email: doc['email'],
                                    radius: 16,
                                    fontSize: 14), // 改小头像和字体
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc['email'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  doc['comment'],
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isLiked
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_off_alt,
                                        color: isLiked ? Colors.blue : null,
                                        size: 16,
                                      ),
                                      onPressed: () async {
                                        try {
                                          if (isLiked) {
                                            await _firestore
                                                .collection('posts')
                                                .doc(postId)
                                                .collection('comments')
                                                .doc(doc.id)
                                                .update({
                                              'likes': FieldValue.arrayRemove(
                                                  [user.uid])
                                            });
                                          } else {
                                            await _firestore
                                                .collection('posts')
                                                .doc(postId)
                                                .collection('comments')
                                                .doc(doc.id)
                                                .update({
                                              'likes': FieldValue.arrayUnion(
                                                  [user.uid])
                                            });
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('更新点赞失败: $e')), // 错误提示
                                          );
                                        }
                                      },
                                    ),
                                    Text(likesCount.toString(),
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: '输入评论',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_commentController.text.isNotEmpty) {
                      try {
                        await _firestore
                            .collection('posts')
                            .doc(postId)
                            .collection('comments')
                            .add({
                          'comment': _commentController.text,
                          'userId': user.uid,
                          'email': user.email,
                          'timestamp': FieldValue.serverTimestamp(),
                          'likes': [],
                        });
                        _commentController.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('发布评论失败: $e')), // 错误提示
                        );
                      }
                    }
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
