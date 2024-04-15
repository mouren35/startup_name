import 'package:flutter/material.dart';

class FinishNotePage extends StatefulWidget {
  const FinishNotePage({Key? key}) : super(key: key);

  @override
  State<FinishNotePage> createState() => _FinishNotePageState();
}

class _FinishNotePageState extends State<FinishNotePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('复习完成啦！'),
    );
  }
}
