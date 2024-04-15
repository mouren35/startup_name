import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController stepsController = TextEditingController();

  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double timeValue = 0;
    final formKey = GlobalKey<FormState>();
    final provider = Provider.of<TaskDB>(context);

    Widget _buildslider = Slider(
      min: 0,
      value: timeValue,
      max: 60,
      divisions: 60,
      onChanged: (newValue) {
        setState(() => timeValue = newValue);
      },
      label: '$timeValue分钟',
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
            key: formKey,
            child: TextFormField(
              minLines: 1,
              maxLines: 2,
              controller: titleController,
              decoration: const InputDecoration(labelText: '在此添加事项标题'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "标题输入不能为空";
                }
                return null;
              },
            ),
          ),
          bottom: const TabBar(tabs: [Tab(text: '步骤'), Tab(text: '笔记')]),
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
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: '在此添加事项步骤',
                  ),
                ),
                _buildslider,
                Expanded(child: Container()),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('添加'),
                        ),
                        onPressed: () {
                          String title = titleController.text;
                          String note = noteController.text;
                          String steps = stepsController.text;

                          int currentTime = timeValue.floor();
                          if (formKey.currentState!.validate() &&
                              timeValue != 0) {
                            provider.addTask(
                              TaskModel(
                                title: title,
                                note: note,
                                steps: steps,
                                taskTime: currentTime,
                              ),
                            );
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
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: '在此添加笔记',
                  ),
                ),
                _buildslider,
                Expanded(child: Container()),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('添加'),
                        ),
                        onPressed: () {
                          String title = titleController.text;
                          String note = noteController.text;
                          String steps = stepsController.text;

                          int time1 = timeValue.floor();

                          if (formKey.currentState!.validate() &&
                              timeValue != 0) {
                            provider.addTask(TaskModel(
                                title: title,
                                note: note,
                                steps: steps,
                                taskTime: time1));
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
            )
          ],
        ),
      ),
    );
  }
}
