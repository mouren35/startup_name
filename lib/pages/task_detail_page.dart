import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';

class TaskDetailPage extends StatefulWidget {
  final int timeValue;
  const TaskDetailPage({Key? key, required this.timeValue}) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);
    return Scaffold(
      body: FutureBuilder(
        future: provider.getTask(),
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
                            subtitle: Text('预计时间${widget.timeValue}'),
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
