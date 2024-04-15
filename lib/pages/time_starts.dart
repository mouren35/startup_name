import 'package:flutter/material.dart';

import '../model/things.dart';
import '../model/things_helper.dart';
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
      body: const CircleTime(),
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

  Future<List<dynamic>> chushihua() async {
    return (await thingItem.retrieveThings());
  }

  @override
  void initState() {
    thingItem = ThingsHandler();
    super.initState();
    chushihua();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: thingItem.retrieveThings(),
      builder: (BuildContext context, AsyncSnapshot<List<Things>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = [
            const Expanded(
              child: CitcleCount(),
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
