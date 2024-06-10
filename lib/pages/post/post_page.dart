import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startup_namer/pages/login/login_page.dart';
import 'package:startup_namer/pages/post/post_detail.dart';
import 'package:startup_namer/pages/post/release_post_page.dart';
import 'package:intl/intl.dart'; // For date formatting

class PostScreen extends StatelessWidget {
  final User user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PostScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          CircleAvatar(
            radius: 20,
            child: Text(
              user.email!.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewPostScreen(user: user)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              bool isLiked = doc['likes'].contains(user.uid);
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Text(doc['email'].substring(0, 1).toUpperCase()),
                ),
                title: Text(doc['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc['content']),
                    Text(DateFormat('yyyy-MM-dd – kk:mm')
                        .format(doc['timestamp'].toDate())),
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
                      await _firestore.collection('posts').doc(doc.id).update({
                        'likes': FieldValue.arrayRemove([user.uid])
                      });
                    } else {
                      // Add like
                      await _firestore.collection('posts').doc(doc.id).update({
                        'likes': FieldValue.arrayUnion([user.uid])
                      });
                    }
                  },
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
