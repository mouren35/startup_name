import 'package:flutter/material.dart';
import 'package:startup_namer/model/note_model.dart';
import 'package:startup_namer/pages/note/add_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final NoteModel? note;

  const NoteDetailPage({Key? key, this.note}) : super(key: key);

  @override
  State createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("详情页"),
        actions: [
          _buildEditButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText("问题:", widget.note?.title ?? 'No title'),
                    const SizedBox(height: 20),
                    _buildText("答案:", widget.note?.answer ?? '空'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        _navigateToAddNotePage();
      },
    );
  }

  void _navigateToAddNotePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNotePage(note: widget.note),
      ),
    );
  }

  Widget _buildText(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
