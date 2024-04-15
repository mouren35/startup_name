import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/note_model.dart';
import 'package:startup_namer/widget/show_toast.dart';

import '../db/note_db.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final provider = Provider.of<NoteDb>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              String title = titleController.text;
              String answer = answerController.text;

              if (formKey.currentState!.validate()) {
                provider.addNote(NoteModel(title: title, answer: answer));

                ShowToast().showToast(
                  msg: "添加成功",
                  backgroundColor: Colors.green,
                );

                titleController.clear();
                answerController.clear();
              }
            },
            child: const Text('添加'),
          )
        ],
        title: const Text('添加笔记'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 15.0),
        child: Column(
          children: <Widget>[
            TextFormField(
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
            TextFormField(
              // cursorColor: Colors.black,
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
          ],
        ),
      ),
    );
  }
}
