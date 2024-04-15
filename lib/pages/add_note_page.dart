import 'package:flutter/material.dart';

import '../db/note_db.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late NoteDb handler;

  TextEditingController titleController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    handler = NoteDb();
    handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              String title = titleController.text;
              String answer = answerController.text;

              if (formKey.currentState!.validate()) {
                _insert(title, answer);
                titleController.clear();
                answerController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('添加失败')),
                );
              }
            },
            child: const Text(
              '添加',
              style: TextStyle(
                color: Color.fromARGB(255, 14, 75, 132),
              ),
            ),
          )
        ],
        title: const Text('添加笔记'),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 4,
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Font",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "输入不能为空";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    minLines: 1,
                    maxLines: 5,
                    controller: answerController,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: "Back",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "输入不能为空";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _insert(title, answer) async {
    _showMessageInScaffold('添加成功');
  }
}
