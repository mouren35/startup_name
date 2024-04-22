import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/task_db.dart';
import '../widget/circular_timer.dart';

class TimerPage extends StatelessWidget {
  final int id;
  final String title;
  final int seconds;
  final String note;
  final String step;

  const TimerPage({
    Key? key,
    required this.title,
    required this.seconds,
    required this.id,
    required this.note,
    required this.step,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);
    final cardWidth = MediaQuery.of(context).size.width - 30;
    final cardHeight = cardWidth;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularTimer(
                      durationInSeconds: seconds * 60, // 设定总时间（以秒为单位）
                      size: 200.0, // 设定圆形进度条的大小
                      color: Colors.blue, // 设定圆形进度条的颜色
                    ),
                    IconButton(
                      onPressed: () {
                        provider.updateTask(id, 1);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check_circle_outline),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        note,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
