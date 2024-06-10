import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting

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
        title: const Text('Post Detail'),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Text(
                          post['email'].substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      title: Text(
                        post['title'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post['content'], style: const TextStyle(fontSize: 18)),
                          Text(DateFormat('yyyy-MM-dd – kk:mm')
                              .format(post['timestamp'].toDate())),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                          color: isLiked ? Colors.blue : null,
                        ),
                        onPressed: () async {
                          if (isLiked) {
                            // Remove like
                            await _firestore
                                .collection('posts')
                                .doc(postId)
                                .update({
                              'likes': FieldValue.arrayRemove([user.uid])
                            });
                          } else {
                            // Add like
                            await _firestore
                                .collection('posts')
                                .doc(postId)
                                .update({
                              'likes': FieldValue.arrayUnion([user.uid])
                            });
                          }
                        },
                      ),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Comments',
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
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  child: Text(
                                    doc['email'].substring(0, 1).toUpperCase(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                title: Text(
                                  doc['comment'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  DateFormat('yyyy-MM-dd – kk:mm')
                                      .format(doc['timestamp'].toDate()),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    isLiked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_off_alt,
                                    color: isLiked ? Colors.blue : null,
                                  ),
                                  onPressed: () async {
                                    if (isLiked) {
                                      // Remove like
                                      await _firestore
                                          .collection('posts')
                                          .doc(postId)
                                          .collection('comments')
                                          .doc(doc.id)
                                          .update({
                                        'likes':
                                            FieldValue.arrayRemove([user.uid])
                                      });
                                    } else {
                                      // Add like
                                      await _firestore
                                          .collection('posts')
                                          .doc(postId)
                                          .collection('comments')
                                          .doc(doc.id)
                                          .update({
                                        'likes':
                                            FieldValue.arrayUnion([user.uid])
                                      });
                                    }
                                  },
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(labelText: 'Comment'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_commentController.text.isNotEmpty) {
                      var currentUser = FirebaseAuth.instance.currentUser;
                      await _firestore
                          .collection('posts')
                          .doc(postId)
                          .collection('comments')
                          .add({
                        'comment': _commentController.text,
                        'userId': currentUser!.uid,
                        'email': currentUser.email,
                        'timestamp': FieldValue.serverTimestamp(),
                        'likes': [], // Initialize likes as an empty array
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
