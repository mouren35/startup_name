import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String email;
  final double radius;
  final double fontSize;

  UserAvatar({required this.email, this.radius = 20, this.fontSize = 20});

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
