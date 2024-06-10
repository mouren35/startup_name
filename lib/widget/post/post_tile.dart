import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'user_avatar.dart';

class PostTile extends StatelessWidget {
  final DocumentSnapshot post;
  final User user;
  final Function onTap;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PostTile({required this.post, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isLiked = post['likes'].contains(user.uid);
    int likesCount = post['likes'].length;
    Timestamp? timestamp = post['timestamp'];
    String formattedTime = timestamp != null
        ? DateFormat('yyyy-MM-dd – kk:mm').format(timestamp.toDate())
        : '无日期信息';

    return ListTile(
      leading: UserAvatar(email: post['email']),
      title: Text(post['title']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post['content']),
          Text(formattedTime),
        ],
      ),
      trailing: Column(
        children: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
              color: isLiked ? Colors.blue : null,
            ),
            onPressed: () async {
              if (isLiked) {
                await _firestore.collection('posts').doc(post.id).update({
                  'likes': FieldValue.arrayRemove([user.uid])
                });
              } else {
                await _firestore.collection('posts').doc(post.id).update({
                  'likes': FieldValue.arrayUnion([user.uid])
                });
              }
            },
          ),
          Text(likesCount.toString()),
        ],
      ),
      onTap: () => onTap(),
    );
  }
}
