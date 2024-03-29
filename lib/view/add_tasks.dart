import 'package:flutter/material.dart';
import 'package:startup_namer/Database/things.dart';
import 'package:startup_namer/Database/things_helper.dart';

int timeValue = 0;

class AddTasks extends StatelessWidget {
  const AddTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AddTaskForm(),
    );
  }
}

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({Key? key}) : super(key: key);

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  late ThingsHandler thingsItem;

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController stepsController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    Widget slider = Slider(
      activeColor: const Color.fromARGB(255, 14, 75, 132),
      thumbColor: const Color.fromARGB(255, 14, 75, 132),
      min: 0,
      value: timeValue.toDouble(),
      max: 60,
      divisions: 60,
      onChanged: (newValue) {
        setState(() {
          timeValue = newValue.toInt();
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
            key: formKey,
            child: TextFormField(
              minLines: 1,
              maxLines: 2,
              controller: titleController,
              decoration: const InputDecoration(
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
          bottom: const TabBar(
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
                  decoration: const InputDecoration(
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
                        color: const Color.fromARGB(255, 14, 75, 132),
                        textColor: Colors.white,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('添加'),
                        ),
                        onPressed: () {
                          String title = titleController.text;
                          String note = noteController.text;
                          String steps = stepsController.text;

                          String time1 = timeValue.toString();
                          if (formKey.currentState!.validate() &&
                              timeValue != 0) {
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
                  decoration: const InputDecoration(
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
                        color: const Color.fromARGB(255, 14, 75, 132),
                        textColor: Colors.white,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('添加'),
                        ),
                        onPressed: () {
                          String title = titleController.text;
                          String note = noteController.text;
                          String steps = stepsController.text;

                          String time1 = timeValue.toString();

                          if (formKey.currentState!.validate() &&
                              timeValue != 0) {
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
