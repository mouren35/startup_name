import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_timer/simple_timer.dart';

import '../db/task_db.dart';

class CitcleCount extends StatefulWidget {
  const CitcleCount({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CitcleCountState createState() => _CitcleCountState();
}

class _CitcleCountState extends State<CitcleCount>
    with SingleTickerProviderStateMixin {
  late TimerController _timerController;
  final TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;
  final TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;

  late TaskDB thingsItem;

  @override
  void initState() {
    thingsItem = TaskDB();

    _timerController = TimerController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime pauseTime;
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: SimpleTimer(
                  status: TimerStatus.start,
                  duration: Duration(minutes: int.parse("20")),
                  valueListener: timerValueChangeListener,
                  progressIndicatorDirection: _progressIndicatorDirection,
                  progressTextCountDirection: _progressTextCountDirection,
                  strokeWidth: 10,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          _timerController.pause;
                          pauseTime = DateTime.now();
                          var cha = Duration(
                            minutes: pauseTime
                                .difference("30" as DateTime)
                                .inSeconds,
                          );

                          log(cha.toString());

                          thingsItem.initializeDB();
                          setState(() {});

                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 14, 75, 132)),
                        child: const Text(
                          "Finish",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void timerValueChangeListener(Duration timeElapsed) {}
}
