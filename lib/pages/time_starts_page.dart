import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';

var pauseTime;
late TaskModel thing1;

class TimeStartPage extends StatefulWidget {
  const TimeStartPage({Key? key}) : super(key: key);

  @override
  State<TimeStartPage> createState() => _TimeStartPageState();
}

class _TimeStartPageState extends State<TimeStartPage>
    with SingleTickerProviderStateMixin {
  late TaskDB thingItem;

  Future<List<dynamic>> chushihua() async {
    return (await thingItem.queryTask());
  }

  @override
  void initState() {
    thingItem = TaskDB();
    super.initState();
    chushihua();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: thingItem.queryTask(),
      builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = [
            Expanded(
              flex: 1,
              child: _buildCircularCountdownTimer(),
            ),
          ];
        } else if (snapshot.hasError) {
          return Text('$snapshot');
        } else {
          children = <Widget>[
            const SizedBox(
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

  _buildCircularCountdownTimer() {
    return CircularCountDownTimer(
      duration: 10,
      initialDuration: 0,
      controller: CountDownController(),
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      ringColor: Colors.grey[300]!,
      ringGradient: null,
      fillColor: Colors.pink,
      fillGradient: null,
      backgroundColor: null,
      backgroundGradient: null,
      strokeWidth: 20.0,
      strokeCap: StrokeCap.round,
      textStyle: const TextStyle(
          fontSize: 33.0, color: Colors.black, fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.S,
      isReverse: true,
      isReverseAnimation: false,
      isTimerTextShown: true,
      autoStart: true,
      onStart: () {
        print('Countdown Started');
      },
      onComplete: () {
        print('Countdown Ended');
      },
    );
  }
}
