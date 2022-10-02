import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:startup_namer/Database/Things.dart';
import 'package:startup_namer/Database/ThingsHelper.dart';
import 'package:logger/logger.dart';

int timeValue = 0;
// String taskTime = value.toString();

class AddTasks extends StatelessWidget {
  const AddTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: addTaskForm(),
    );
  }
}

class addTaskForm extends StatefulWidget {
  addTaskForm({Key? key}) : super(key: key);

  @override
  State<addTaskForm> createState() => _addTaskFormState();
}

class _addTaskFormState extends State<addTaskForm> {
  late ThingsHandler thingsItem;

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController stepsController = TextEditingController();
  // TextEditingController timeController = TextEditingController();

  // double value = 2;
  // String taskTime = '';

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
    thingsItem = ThingsHandler();
    // thingsItem.initializeDB().whenComplete(() async {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    Widget slider = Slider(
      activeColor: Color.fromARGB(255, 14, 75, 132),
      thumbColor: Color.fromARGB(255, 14, 75, 132),
      min: 0,
      value: timeValue.toDouble(),
      max: 60,
      divisions: 60,
      onChanged: (newValue) {
        setState(() {
          timeValue = newValue.toInt();
          // timeValue = 0.toInt();
        });
      },
      label: '${timeValue.toInt()}分钟',
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Form(
            key: _formKey,
            child: TextFormField(
              minLines: 1,
              maxLines: 2,
              controller: titleController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: '在此添加事项标题',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "标题输入不能为空";
                }
                return null;
              },
            ),
          ),
          bottom: TabBar(
            indicatorColor: Color.fromARGB(255, 14, 75, 132),
            labelColor: Colors.black,
            tabs: [
              Tab(text: '步骤'),
              Tab(text: '笔记'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 9,
                  controller: noteController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: '在此添加事项步骤',
                  ),
                ),
                slider,
                Expanded(child: Container()),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Color.fromARGB(255, 14, 75, 132),
                        textColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('添加'),
                        ),
                        onPressed: () {
                          String title = titleController.text;
                          String note = noteController.text;
                          String steps = stepsController.text;
                          // log();
                          String time1 = timeValue.toString();
                          if (_formKey.currentState!.validate() &&
                              timeValue != 0) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            _insert(title, note, steps, time1);
                            titleController.clear();
                            noteController.clear();
                            stepsController.clear();
                          } else {
                            if (timeValue == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('时间不能为0')),
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('添加失败')),
                            );
                          }
                          timeValue = 0;
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                TextField(
                  minLines: 1,
                  maxLines: 9,
                  controller: stepsController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: '在此添加笔记',
                  ),
                ),
                slider,
                Expanded(child: Container()),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Color.fromARGB(255, 14, 75, 132),
                        textColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('添加'),
                        ),
                        onPressed: () {
                          String title = titleController.text;
                          String note = noteController.text;
                          String steps = stepsController.text;
                          // String time = timeController.text;
                          String time1 = timeValue.toString();

                          if (_formKey.currentState!.validate() &&
                              timeValue != 0) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            _insert(title, note, steps, time1);
                            titleController.clear();
                            noteController.clear();
                            stepsController.clear();
                            // timeController.clear();
                          } else {
                            if (timeValue == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('时间不能为0')),
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('添加失败')),
                            );
                          }
                          timeValue = 0;
                        },
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _insert(
    title,
    note,
    steps,
    time,
  ) async {
    Map<String, dynamic> row = {
      ThingsHandler.columnTitle: title,
      ThingsHandler.columnNote: note,
      ThingsHandler.columnSteps: steps,
      ThingsHandler.columnTasktime: time
    };

    Things thing = Things.fromMap(row);
    await thingsItem.insertThing(thing);
    _showMessageInScaffold('添加成功');
  }
}
