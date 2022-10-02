import 'package:flutter/material.dart';
import 'Database/Questions.dart';
import 'Database/QuestionHelper.dart';

class AddNotes extends StatelessWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddNotesForm(),
    );
  }
}

class AddNotesForm extends StatefulWidget {
  AddNotesForm({Key? key}) : super(key: key);

  @override
  State<AddNotesForm> createState() => _AddNotesFormState();
}

class _AddNotesFormState extends State<AddNotesForm> {
  late DatabaseHandler handler;

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
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String title = titleController.text;
              String answer = answerController.text;

              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                _insert(title, answer);
                titleController.clear();
                answerController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('添加失败')),
                );
              }
            },
            child: Text(
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
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  // child: Expanded(
                  child: TextFormField(
                    cursorColor: Colors.black,
                    minLines: 1,
                    maxLines: 4,
                    // 不要忘记controller！！！！
                    controller: titleController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: "Font",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "输入不能为空";
                      }
                      return null;
                    },
                  ),
                  // ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    minLines: 1,
                    maxLines: 5,
                    // 不要忘记controller！！！！
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
                // Padding(
                //   padding: const EdgeInsets.only(top: 16.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     // crossAxisAlignment: CrossAxisAlignment.start,
                //     // mainAxisSize: MainAxisSize.max,
                //     children: [
                //       // Expanded(
                //       // child:
                //       MaterialButton(
                //         // minWidth: double.infinity,
                //         color: Color.fromARGB(255, 14, 75, 132),
                //         textColor: Colors.white,
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text('添加'),
                //         ),
                //         onPressed: () {},
                //       ),
                //       // ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _insert(title, answer) async {
    Map<String, dynamic> row = {
      DatabaseHandler.columnTitle: title,
      DatabaseHandler.columnAnswer: answer,
    };

    Question question = Question.fromMap(row);
    final id = await this.handler.insertQuestions(question);
    _showMessageInScaffold('添加成功');
  }
}
