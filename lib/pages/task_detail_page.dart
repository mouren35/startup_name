import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/pages/timer_page.dart';
import 'package:startup_namer/util/navigator_util.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';

class TaskDetailPage extends StatelessWidget {
  final int time;
  final String title;
  final String? step;
  final String? note;
  final int? id;

  const TaskDetailPage({
    Key? key,
    required this.time,
    required this.title,
    this.step,
    this.note,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('任务详情')),
      body: TaskDetailContent(
        title: title,
        time: time,
        step: step ?? '',
        note: note ?? '',
        id: id,
      ),
    );
  }
}

class TaskDetailContent extends StatelessWidget {
  final String title;
  final int time;
  final String step;
  final String note;
  final int? id;

  const TaskDetailContent({
    Key? key,
    required this.title,
    required this.time,
    required this.step,
    required this.note,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDB>(
      builder: (context, provider, child) {
        return FutureBuilder(
          future: provider.getTask(),
          builder:
              (BuildContext context, AsyncSnapshot<List<TaskModel>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              final task = snapshot.data!.firstWhere((t) => t.id == id);
              return TaskDetailView(
                task: task,
                title: title,
                time: time,
                step: step,
                note: note,
                id: id,
              );
            }
          },
        );
      },
    );
  }
}

class TaskDetailView extends StatelessWidget {
  final TaskModel task;
  final int time;
  final String title;
  final String? step;
  final String? note;
  final int? id;

  const TaskDetailView({
    Key? key,
    required this.task,
    required this.time,
    required this.title,
    this.step,
    this.note,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TaskInfoCard(title: title, time: time, color: task.taskColor),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailText('步骤：', step ?? '无'),
                  const SizedBox(height: 20),
                  _buildDetailText('备注：', note ?? '无'),
                  const SizedBox(height: 20),
                  _buildDetailText('重复周期：',
                      _formatRepeat(task.repeatType, task.repeatInterval)),
                
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _startTimer(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              '开始计时',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  void _startTimer(BuildContext context) {
    NavigatorUtil.push(
      context,
      TimerPage(
        title: title,
        seconds: time,
        id: id,
        note: note ?? '',
        step: step ?? '',
      ),
    );
  }

    String _formatRepeat(String type, int interval) {
    if (type == '不重复') return type;
    return '$interval $type';
  }
}

class TaskInfoCard extends StatelessWidget {
  final String title;
  final int time;
  final Color color; // 添加颜色属性

  const TaskInfoCard({
    Key? key,
    required this.title,
    required this.time,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color, // 使用颜色属性
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            '预计时间: $time 分钟',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
