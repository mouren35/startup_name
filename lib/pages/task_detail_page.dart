import 'package:flutter/material.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';
import 'add_task_page.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({Key? key}) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TaskDB thingItem;

  @override
  void initState() {
    super.initState();
    thingItem = TaskDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: thingItem.retrieveThings(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: const TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                            subtitle: Text('预计时间$timeValue'),
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: const [
                          TextField(),
                          TextField(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
