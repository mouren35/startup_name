import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:startup_namer/widget/post/user_avatar.dart'; // For date formatting

class PostDetailScreen extends StatelessWidget {
  final String postId;
  final User user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _commentController = TextEditingController();

  PostDetailScreen({super.key, required this.postId, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帖子详情'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('posts').doc(postId).snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
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
                          email: post['email'], radius: 30, fontSize: 24),
                      title: Text(
                        post['title'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post['content'], style: const TextStyle(fontSize: 18)),
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
                            },
                          ),
                          Text(likesCount.toString()),
                        ],
                      ),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
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
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
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
                                    radius: 20,
                                    fontSize: 16),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc['email'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  doc['comment'],
                                  style: const TextStyle(fontSize: 16),
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
                                      },
                                    ),
                                    Text(likesCount.toString(),
                                        style: const TextStyle(fontSize: 12)),
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
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: '输入评论',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_commentController.text.isNotEmpty) {
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
