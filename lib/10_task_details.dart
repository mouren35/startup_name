import 'package:flutter/material.dart';
import 'Database/ThingsHelper.dart';
import 'Database/Things.dart';
import '05_add_tasks.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: TaskDetail(),
    );
  }
}

class TaskDetail extends StatefulWidget {
  TaskDetail({Key? key}) : super(key: key);

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late ThingsHandler thingItem;

  @override
  void initState() {
    super.initState();
    this.thingItem = ThingsHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.thingItem.retrieveThings(),
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
                            title: TextField(
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
                        children: [
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
