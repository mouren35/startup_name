import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:startup_namer/pages/post/post_detail.dart';
import 'package:startup_namer/pages/post/release_post_page.dart';
import 'package:startup_namer/pages/user/user_detail_page.dart';
import 'package:startup_namer/widget/post/user_avatar.dart';

class PostScreen extends StatelessWidget {
  final User user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PostScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帖子列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPostScreen(user: user),
                ),
              );
            },
          ),
          IconButton(
            icon: UserAvatar(email: user.email!, radius: 16, fontSize: 16),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserDetailScreen(user: user)),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('加载帖子时出错: ${snapshot.error}')); // 错误提示
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('还没有帖子，快来发布吧！')); // 提示语
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              bool isLiked = doc['likes'].contains(user.uid);
              int likesCount = doc['likes'].length;
              Timestamp? timestamp = doc['timestamp'];
              String formattedTime = timestamp != null
                  ? DateFormat('yyyy-MM-dd – kk:mm').format(timestamp.toDate())
                  : '无日期信息';

              return ListTile(
                leading: UserAvatar(
                    email: doc['email'], radius: 20, fontSize: 16), // 改小头像和字体
                title: Text(doc['title'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)), // 改小字体
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc['content'],
                        style: const TextStyle(fontSize: 16)), // 改小字体
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
                                .doc(doc.id)
                                .update({
                              'likes': FieldValue.arrayRemove([user.uid])
                            });
                          } else {
                            await _firestore
                                .collection('posts')
                                .doc(doc.id)
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PostDetailScreen(postId: doc.id, user: user),
                    ),
                  );
                },
                onLongPress: () async {
                  if (doc['userId'] == user.uid) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('确认删除'),
                        content: const Text('确定要删除这个帖子吗？'),
                        actions: [
                          TextButton(
                            child: const Text('取消'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text('删除'),
                            onPressed: () async {
                              Navigator.pop(context);
                              try {
                                await _firestore
                                    .collection('posts')
                                    .doc(doc.id)
                                    .delete();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('删除帖子失败: $e')), // 错误提示
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
