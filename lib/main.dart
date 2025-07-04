import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/core/firebase_options.dart';
import 'package:startup_namer/pages/login/login_page.dart';
import 'package:startup_namer/providers/diary_provider.dart';

import 'services/note_db.dart';
import 'services/task_db.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:startup_namer/core/theme.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskDB()..init()),
        ChangeNotifierProvider(create: (_) => NoteDb()..init()),
        ChangeNotifierProvider(create: (_) => DiaryProvider()),
        // ChangeNotifierProvider(create: (context) => HabitProvider()),
        // ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'time_review',
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
    );
  }
}
