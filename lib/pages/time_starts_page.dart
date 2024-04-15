import 'package:flutter/material.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';
import 'countdown_timer.dart';

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
    return (await thingItem.retrieveThings());
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
      future: thingItem.retrieveThings(),
      builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = [
            const Expanded(
              child: CitcleCount(
                title: '',
              ),
            ),
            Expanded(child: Container()),
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
}
