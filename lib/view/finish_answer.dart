import 'package:flutter/material.dart';

class FinishAnswer extends StatelessWidget {
  const FinishAnswer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('复习完成')),
      body: const FinishAnswerPage(),
    );
  }
}

class FinishAnswerPage extends StatefulWidget {
  const FinishAnswerPage({Key? key}) : super(key: key);

  @override
  State<FinishAnswerPage> createState() => _FinishAnswerPageState();
}

class _FinishAnswerPageState extends State<FinishAnswerPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('复习完成啦！'),
    );
  }
}
