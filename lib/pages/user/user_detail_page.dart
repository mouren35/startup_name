import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:startup_namer/pages/login/login_page.dart';
import 'package:startup_namer/widget/post/user_avatar.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户详情'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserAvatar(email: user.email!, radius: 40, fontSize: 40),
            const SizedBox(height: 16),
            Text(user.email!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: const Text('注销'),
            ),
          ],
        ),
      ),
    );
  }
}
