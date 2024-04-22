import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';

class TaskDetailPage extends StatelessWidget {
  final int time;
  final String title;

  const TaskDetailPage({Key? key, required this.time, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Consumer<TaskDB>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: provider.getTask(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TaskModel>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                return TaskDetailView(task: snapshot.data!.first, time: time);
              }
            },
          );
        },
      ),
    );
  }
}

class TaskDetailView extends StatelessWidget {
  final TaskModel task;
  final int time;

  const TaskDetailView({Key? key, required this.task, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: ListTile(
              title: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
              subtitle: Text('预计时间 $time 分钟'),
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: Column(
              children: [
                TextField(),
                TextField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
