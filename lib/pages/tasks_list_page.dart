import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/pages/task_detail_page.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';
import 'time_starts_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late int currentTime;
  late DateTime nowTime;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('事项')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            children: const [
              ListTile(title: Text('未完成', textScaleFactor: 1.5))
            ],
          ),
          Expanded(
            child: SizedBox(
              child: FutureBuilder(
                future: provider.getTask(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TaskModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final data = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: const Icon(Icons.delete_forever),
                        ),
                        onDismissed: (DismissDirection direction) async {
                          await provider.deleteThing(data[index].id!);
                          SnackBar snackbar = SnackBar(
                            content: const Text('已删除'),
                            action: SnackBarAction(
                              label: '撤销',
                              onPressed: () {
                                setState(() {
                                  provider.addTask(data[index]);
                                });
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        },
                        key: UniqueKey(),
                        child: Column(
                          children: [
                            Scrollbar(
                              child: SingleChildScrollView(
                                child: ListTile(
                                  leading: Text('${data[index].taskTime}'),
                                  title: Text(data[index].title),
                                  subtitle: Text(data[index].note.toString()),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () {
                                      nowTime = DateTime.now();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            currentTime = data[index].taskTime;

                                            return const TimeStartPage();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => TaskDetailPage(
                                          timeValue: data[index].taskTime,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Stack(
            children: const [
              ListTile(
                title: Text(
                  '已完成',
                  textScaleFactor: 1.5,
                ),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              child: FutureBuilder(
                future: provider.getTask(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TaskModel>> snapshot) {
                  return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Scrollbar(
                          child: SingleChildScrollView(
                        child: ListTile(
                          title: const Text('事项2'),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const TimeStartPage(),
                                ),
                              );
                            },
                          ),
                          onTap: () {},
                        ),
                      ));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}