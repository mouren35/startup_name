import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';
import '../widget/task_expansion_tile.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return FutureBuilder(
      future: provider.getTask(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<TaskModel>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data ?? [];
        final undoTask = data.where((task) => task.taskStatus == 0).toList();
        final completedTask =
            data.where((task) => task.taskStatus == 1).toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              TaskExpansionTile(
                title: '未完成',
                tasks: undoTask,
              ),
              TaskExpansionTile(
                title: '完成',
                tasks: completedTask,
              ),
            ],
          ),
        );
      },
    );
  }
}
