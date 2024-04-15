import 'package:flutter/material.dart';
import 'dart:async';

class CircleCountDown extends StatefulWidget {
  const CircleCountDown({Key? key}) : super(key: key);

  @override
  State<CircleCountDown> createState() => _CircleCountDownState();
}

class _CircleCountDownState extends State<CircleCountDown> {
  ///声明变量
  late Timer _timer;

  ///记录当前的时间
  int curentTimer = (int.parse("20") + 1) * 1000;
  int curentTimer1 = 0;

  @override
  void initState() {
    super.initState();

    ///循环执行
    ///间隔1秒
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ///自增
      curentTimer -= 100;
      curentTimer1 += 100;

      ///到5秒后停止
      if (curentTimer <= 0) {
        _timer.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    ///取消计时器
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            ///层叠布局将进度与文字叠在一起
            Stack(
              ///子Widget居中
              alignment: Alignment.center,
              children: [
                ///圆形进度
                CircularProgressIndicator(
                  ///当前指示的进度 0.0 -1.0
                  value: curentTimer1 / 50,
                ),

                ///显示的文本
                Text("${curentTimer ~/ 1000}"),
              ],
            )
          ],
        ));
  }
}
