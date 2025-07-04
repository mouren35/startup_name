import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String email;
  final double radius;
  final double fontSize;

  const UserAvatar(
      {super.key, required this.email, this.radius = 16, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: Text(
        email.substring(0, 1).toUpperCase(),
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
