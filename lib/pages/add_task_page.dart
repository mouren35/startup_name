import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/widget/show_toast.dart';

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

  @override
  Widget build(BuildContext context) {
    double time = 0;
    final formKey = GlobalKey<FormState>();
    final provider = Provider.of<TaskDB>(context);

    Duration duration = Duration(seconds: 0);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TextFormField(
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
          bottom: const TabBar(tabs: [Tab(text: '步骤'), Tab(text: '笔记')]),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0),
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 9,
                    controller: noteController,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: '在此添加内容',
                    ),
                  ),
                  DurationPicker(
                    baseUnit: BaseUnit.minute,
                    duration: duration,
                    onChange: (val) {
                      setState(() => duration = val);
                    },
                    snapToMins: 5.0,
                  ),
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

                            int currentTime = time.floor();
                            if (formKey.currentState!.validate() && time != 0) {
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
                              if (time == 0) {
                                ShowToast().showToast(
                                  msg: "时间不能为0",
                                  backgroundColor: Colors.red,
                                );
                              }
                            }
                            time = 0;
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
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
                // _buildslider,
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

                          int time1 = time.floor();

                          if (formKey.currentState!.validate() && time != 0) {
                            provider.addTask(TaskModel(
                                title: title,
                                note: note,
                                steps: steps,
                                taskTime: time1));
                            titleController.clear();
                            noteController.clear();
                            stepsController.clear();
                          } else {
                            if (time == 0) {
                              ShowToast().showToast(
                                msg: "时间不能为0",
                                backgroundColor: Colors.red,
                              );
                            }
                          }
                          time = 0;
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
