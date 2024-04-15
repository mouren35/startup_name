import 'package:flutter/material.dart';
import 'package:startup_namer/navigator/bottom_navigator.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'time_review',
      theme: ThemeData(useMaterial3: true),
      home: const BottomNavigator(),
    );
  }
}
