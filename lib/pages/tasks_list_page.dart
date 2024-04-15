import 'package:flutter/material.dart';
import 'package:startup_namer/pages/task_detail_page.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';
import 'time_starts_page.dart';

String currentTime = '';
var nowTime;

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late TaskDB thingItem;

  @override
  void initState() {
    super.initState();
    thingItem = TaskDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('事项')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            children: const [
              ListTile(
                title: Text(
                  '未完成',
                  textScaleFactor: 1.5,
                ),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              child: FutureBuilder(
                future: thingItem.queryTask(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TaskModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: const Icon(Icons.delete_forever),
                          ),
                          onDismissed: (DismissDirection direction) async {
                            await thingItem
                                .deleteThing(snapshot.data![index].id!);
                            SnackBar snackbar = SnackBar(
                              content: const Text('已删除'),
                              action: SnackBarAction(
                                label: '撤销',
                                onPressed: () {
                                  setState(() {
                                    thingItem.insertTask(snapshot.data![index]);
                                  });
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          },
                          key: UniqueKey(),
                          child: Column(
                            children: [
                              Scrollbar(
                                  child: SingleChildScrollView(
                                child: ListTile(
                                  leading: Text(snapshot.data![index].taskTime),
                                  title: Text(snapshot.data![index].title),
                                  subtitle: Text(
                                      snapshot.data![index].note.toString()),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () {
                                      nowTime = DateTime.now();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            currentTime =
                                                snapshot.data![index].taskTime;

                                            return const TimeStartPage();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TaskDetailPage(),
                                      ),
                                    );
                                  },
                                ),
                              ))
                            ],
                          ),
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
                future: thingItem.queryTask(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TaskModel>> snapshot) {
                  if (snapshot.hasData) {
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
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
