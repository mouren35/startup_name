import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db/note_db.dart';
import 'db/task_db.dart';
import 'navigator/bottom_navigator.dart';

void main(List<String> args) {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskDB()..init()),
        ChangeNotifierProvider(create: (_) => NoteDb()..init()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'time_review',
      debugShowCheckedModeBanner: false,
      home: BottomNavigator(),
    );
  }
}
