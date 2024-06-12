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
          ), // 将添加按钮放到appbar的action里
          IconButton(
            icon: UserAvatar(email: user.email!, radius: 16, fontSize: 16),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserDetailScreen(user: user)),
              );
            },
          ), // 将头像放在action最后的Iconbutton里
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
                leading:
                    UserAvatar(email: doc['email'], radius: 30, fontSize: 24),
                title: Text(doc['title'],
                    style:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc['content'], style: const TextStyle(fontSize: 18)),
                    Text(formattedTime),
                  ],
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
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
                          },
                        ),
                        Text(likesCount.toString()), // 将点赞数放在点赞按钮的右边
                      ],
                    ),
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
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
