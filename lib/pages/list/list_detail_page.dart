import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/db/task_db.dart';
import 'package:startup_namer/model/task_model.dart';
import 'package:startup_namer/pages/add_task_page.dart';
import 'package:startup_namer/pages/task_detail_page.dart';

class ListDetailPage extends StatelessWidget {
  final int listId;
  final String listTitle;

  const ListDetailPage({
    Key? key,
    required this.listId,
    required this.listTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskDB>(
        builder: (context, provider, child) {
          return FutureBuilder<List<TaskModel>>(
            future: provider.getTasksByListId(listId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tasks available'));
              } else {
                final tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text('预计时间: ${task.taskDuration} 分钟'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailPage(
                              time: task.taskDuration!,
                              title: task.title,
                              step: task.steps,
                              note: task.note,
                              id: task.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
