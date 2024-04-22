import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/util/color.dart';

import '../db/note_db.dart';
import '../model/note_model.dart';
import '../widget/show_toast.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

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
    _titleController = TextEditingController();
    _answerController = TextEditingController();
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
                onPressed: () => _addNote(provider),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('添加笔记'),
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

      provider.addNote(NoteModel(title: title, answer: answer));

      ShowToast().showToast(
        msg: "添加成功",
        backgroundColor: AppColors.successColor,
      );

      _titleController.clear();
      _answerController.clear();
    }
  }
}
