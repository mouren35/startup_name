import 'package:flutter/material.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({Key? key}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(),
        ),
      ),
    );
  }
}
