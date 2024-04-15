import 'package:flutter/material.dart';

class KnowledgeDetails extends StatefulWidget {
  const KnowledgeDetails({Key? key}) : super(key: key);

  @override
  State<KnowledgeDetails> createState() => _KnowledgeDetailsState();
}

class _KnowledgeDetailsState extends State<KnowledgeDetails> {
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
