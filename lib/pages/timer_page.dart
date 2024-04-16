import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/task_db.dart';
import '../widget/circular_timer.dart';

class TimerPage extends StatelessWidget {
  final int id;
  final String title;
  final int seconds;

  const TimerPage({
    super.key,
    required this.title,
    required this.seconds,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularTimer(
            durationInSeconds: seconds, // 设定总时间（以秒为单位）
            size: 200.0, // 设定圆形进度条的大小
            color: Colors.blue, // 设定圆形进度条的颜色
          ),
          IconButton(
              onPressed: () {
                provider.updateTask(id, 1);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_circle_outline))
        ],
      ),
    );
  }
}
