import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';
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

  Duration _duration = const Duration(minutes: 25);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final provider = Provider.of<TaskDB>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Form(
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
          actions: [
            TextButton(
              onPressed: () async {
                final selectedDuration = _showDurationPickerDialog(context);
                if (selectedDuration != null) {
                  setState(() {
                    _duration = selectedDuration;
                  });
                }
              },
              child: Text('${_duration.inMinutes} 分钟'),
            ),
            IconButton(
                onPressed: () {
                  String title = titleController.text;
                  String note = noteController.text;
                  String steps = stepsController.text;

                  if (_duration != const Duration()) {
                    provider.addTask(
                      TaskModel(
                        title: title,
                        note: note,
                        steps: steps,
                        taskTime: _duration.inMinutes,
                      ),
                    );
                    titleController.clear();
                    noteController.clear();
                    stepsController.clear();
                    ShowToast().showToast(
                      msg: "添加成功",
                      backgroundColor: Colors.green,
                    );
                  } else {
                    if (_duration == const Duration()) {
                      ShowToast().showToast(
                        msg: "时间不能为0",
                        backgroundColor: Colors.red,
                      );
                    }
                  }
                  _duration = const Duration(minutes: 25);
                },
                icon: const Icon(Icons.check))
          ],
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

                          if (formKey.currentState!.validate() &&
                              _duration != 0) {
                            provider.addTask(TaskModel(
                                title: title,
                                note: note,
                                steps: steps,
                                taskTime: _duration.inMinutes));
                            titleController.clear();
                            noteController.clear();
                            stepsController.clear();
                          } else {
                            if (_duration == 0) {
                              ShowToast().showToast(
                                msg: "时间不能为0",
                                backgroundColor: Colors.red,
                              );
                            }
                          }
                          _duration = const Duration(minutes: 25);
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

  _showDurationPickerDialog(BuildContext context) async {
    showDurationPicker(
      context: context,
      initialDuration: _duration,
      confirmText: '确定',
      cancelText: '取消',
    ).then((value) {
      if (value != null) {
        setState(() {
          _duration = value;
        });
      }
    });
  }
}
