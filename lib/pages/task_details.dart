import 'package:flutter/material.dart';

import '../model/things.dart';
import '../model/things_helper.dart';
import 'add_tasks.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const TaskDetail(),
    );
  }
}

class TaskDetail extends StatefulWidget {
  const TaskDetail({Key? key}) : super(key: key);

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late ThingsHandler thingItem;

  @override
  void initState() {
    super.initState();
    thingItem = ThingsHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: thingItem.retrieveThings(),
        builder: (BuildContext context, AsyncSnapshot<List<Things>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: const TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                            subtitle: Text('预计时间$timeValue'),
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: const [
                          TextField(),
                          TextField(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
