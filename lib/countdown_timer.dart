import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:startup_namer/08_items_list.dart';
import 'Database/Things.dart';
import 'Database/ThingsHelper.dart';
// import '05_add_tasks.dart';
// import 'package:logger/logger.dart';

var pauseTime;

class CitcleCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CitcleCountTimer(title: 'Simple Timer Widget Demo'),
    );
  }
}

class CitcleCountTimer extends StatefulWidget {
  CitcleCountTimer({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CitcleCountTimerState createState() => _CitcleCountTimerState();
}

class _CitcleCountTimerState extends State<CitcleCountTimer>
    with SingleTickerProviderStateMixin {
  late TimerController _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;

  late ThingsHandler thingsItem;

  @override
  void initState() {
    thingsItem = ThingsHandler();
    // initialize timercontroller
    _timerController = TimerController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: SimpleTimer(
                  status: TimerStatus.start,
                  duration: Duration(minutes: int.parse(currentTime)),
                  // controller: _timerController,
                  // timerStyle: _timerStyle,
                  // onStart: handleTimerOnStart,
                  // onEnd: handleTimerOnEnd,
                  valueListener: timerValueChangeListener,
                  // backgroundColor: Colors.grey,
                  // progressIndicatorColor: Colors.green,
                  progressIndicatorDirection: _progressIndicatorDirection,
                  progressTextCountDirection: _progressTextCountDirection,
                  // progressTextStyle: TextStyle(color: Colors.black),
                  strokeWidth: 10,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                // const Text(
                //   "Timer Status",
                //   textAlign: TextAlign.left,
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // TextButton(
                    //     onPressed: _timerController.start,
                    //     child: const Text("Start",
                    //         style: TextStyle(color: Colors.white)),
                    //     style: TextButton.styleFrom(
                    //         backgroundColor: Colors.green)),
                    TextButton(
                        onPressed: () {
                          _timerController.pause;
                          pauseTime = DateTime.now();
                          var cha = Duration(
                            minutes: pauseTime.difference(nowTime).inSeconds,
                          );
                          // var cha = pauseTime.difference(nowTime);
                          log(cha.toString());
                          // log(pauseTime.toString());
                          thingsItem.initializeDB();
                          setState(() {
                            // thingsItem.
                          });

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Finish",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 14, 75, 132))),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void timerValueChangeListener(Duration timeElapsed) {
    // log(timeElapsed.toString());
  }

  // void handleTimerOnStart() {
  //   print("timer has just started");
  // }

  // void handleTimerOnEnd() {
  //   print("timer has ended");
  // }
}
