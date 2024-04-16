import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/task_db.dart';
import '../widget/task_list.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('任务')),
      body: Column(
        children: <Widget>[
          TaskList(
            title: '未完成',
            fetchTask: () => provider.getTask(),
            completed: false,
          ),
          TaskList(
            title: '已完成',
            fetchTask: () => provider.getTask(),
            completed: true,
          ),
        ],
      ),
    );
  }
}
