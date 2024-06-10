import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:startup_namer/pages/post/post_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Signup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                      await _auth.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  if (userCredential.user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PostScreen(user: userCredential.user!)),
                    );
                  }
                } catch (e) {
                  print('Login error: $e');
                }
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                      await _auth.createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  if (userCredential.user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PostScreen(user: userCredential.user!)),
                    );
                  }
                } catch (e) {
                  print('Signup error: $e');
                }
              },
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
