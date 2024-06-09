import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/note_db.dart';
import '../model/note_model.dart';
import '../widget/show_toast.dart';

class AddNotePage extends StatefulWidget {
  final NoteModel? note;
  const AddNotePage({Key? key, this.note}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _answerController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _answerController = TextEditingController(text: widget.note?.answer);
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteDb>(context);
    var note = widget.note;
    if (note?.title != null) {
      note = NoteModel(
          title: widget.note!.title,
          answer: widget.note!.answer,
          id: widget.note!.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加笔记'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                minLines: 1,
                maxLines: 4,
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "标题",
                  hintText: "请输入标题",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "标题不能为空";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                minLines: 3,
                maxLines: 8,
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: "内容",
                  hintText: "请输入内容",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "内容不能为空";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: note?.title != null
                    ? () => _updateNote(context, note!, provider)
                    : () => _addNote(provider),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: note?.title != null
                    ? const Text('更新笔记')
                    : const Text('添加笔记'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNote(NoteDb provider) {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final answer = _answerController.text;
      final id = DateTime.now().millisecondsSinceEpoch;

      provider.addNote(NoteModel(id: id, title: title, answer: answer));
      ShowToast().showToast(
        msg: "添加成功",
        backgroundColor: Colors.green,
      );

      _titleController.clear();
      _answerController.clear();
    }
  }

  _updateNote(BuildContext context, NoteModel note, NoteDb provider) async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;

      final answer = _answerController.text;

      await provider.update(
        note.id ?? 1111,
        NoteModel(title: title, answer: answer, id: note.id),
      );
      if (context.mounted) {
        ShowToast().showToast(
          msg: "更新成功",
          backgroundColor: Colors.green,
        );
      }
    }
  }
}
