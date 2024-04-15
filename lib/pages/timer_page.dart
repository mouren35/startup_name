import 'package:flutter/material.dart';

import '../widget/circular_timer.dart';

class TimerPage extends StatelessWidget {
  String title;
  int seconds;

  TimerPage({super.key, required this.title, required this.seconds});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: CircularTimer(
          durationInSeconds: seconds, // 设定总时间（以秒为单位）
          size: 200.0, // 设定圆形进度条的大小
          color: Colors.blue, // 设定圆形进度条的颜色
        ),
      ),
    );
  }
}
