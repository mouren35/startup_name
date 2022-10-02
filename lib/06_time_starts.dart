import 'dart:developer';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'Database/ThingsHelper.dart';
import 'Database/Things.dart';
import '08_items_list.dart';
// import 'circle_countdown.dart';
// import 'package:simple_timer/simple_timer.dart';
import 'countdown_timer.dart';

var pauseTime;
late Things thing1;

class TimeStarts extends StatelessWidget {
  const TimeStarts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('计时'),
      ),
      body: CircleTime(),
    );
  }
}

class CircleTime extends StatefulWidget {
  const CircleTime({Key? key}) : super(key: key);

  @override
  State<CircleTime> createState() => _CircleTimeState();
}

class _CircleTimeState extends State<CircleTime>
    with SingleTickerProviderStateMixin {
  late ThingsHandler thingItem;

  // TimerController _timerController = TimerController(this);

  Future<List<dynamic>> chushihua() async {
    return (await thingItem.retrieveThings());
  }

  @override
  void initState() {
    thingItem = ThingsHandler();
    super.initState();
    chushihua();
    // _timerController = TimerController(this);
  }

  @override
  Widget build(BuildContext context) {
    final CountDownController _controller = CountDownController();
    return FutureBuilder(
      future: thingItem.retrieveThings(),
      builder: (BuildContext context, AsyncSnapshot<List<Things>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          // log(snapshot.data.toString());
          children = [
            Expanded(
              child: CitcleCount(),
            ),
            // Expanded(
            //   child: CircleCountDown(),
            // ),

            // CircularCountDownTimer(
            //   duration: int.parse(currentTime) * 60,
            //   initialDuration: 0,
            //   controller: _controller,
            //   width: MediaQuery.of(context).size.width / 2,
            //   height: MediaQuery.of(context).size.height / 2,
            //   ringColor: Color.fromARGB(255, 232, 244, 252),
            //   fillColor: Color.fromARGB(255, 60, 174, 255),
            //   backgroundColor: Color.fromARGB(255, 247, 252, 255),
            //   strokeWidth: 10.0,
            //   strokeCap: StrokeCap.round,
            //   textStyle: const TextStyle(
            //     fontSize: 50.0,
            //     color: Color.fromARGB(255, 82, 90, 117),
            //   ),
            //   textFormat: CountdownTextFormat.S,
            //   isTimerTextShown: true,
            // ),


            // ElevatedButton(
            //   child: Text('完成'),
            //   onPressed: () async {
            //     _controller.pause();
            //     pauseTime = DateTime.now();
            //     var cha =
            //         Duration(minutes: pauseTime.difference(nowTime).inSeconds);
            //     // var cha = pauseTime.difference(nowTime);
            //     // log(cha.toString());
            //     // log(pauseTime.toString());
            //     thing1 = Things(
            //       title: thing1.title,
            //       note: thing1.note,
            //       steps: thing1.steps,
            //       taskTime: thing1.taskTime,
            //       taskStatus: 1,
            //     );
            //     await thingItem.updateThing(thing1);
            //     // print(thing1);
            //     Navigator.of(context).pop();
            //   },
            // ),

            Expanded(child: Container()),
          ];
          // log(DateTime.now().toString());
        } else if (snapshot.hasError) {
          return Text('$snapshot');
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
            )
          ];
        }
        return Column(
          children: children,
        );
      },
    );
  }
}
