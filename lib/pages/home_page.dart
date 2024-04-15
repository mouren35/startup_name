import 'package:flutter/material.dart';
import 'package:startup_namer/pages/add_note_page.dart';

import '../db/note_db.dart';
import '../db/task_db.dart';
import '../model/note_model.dart';
import '../model/task_model.dart';
import 'add_task_page.dart';
import 'note_list_page.dart';
import 'start_review.dart';
import 'tasks_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NoteDb handler = NoteDb();
  TaskDB thingsItem = TaskDB();
  List dataList = [];
  List queryData = [];

  Future<List<dynamic>> chushihua() async {
    queryData = await handler.retrieveQuestions();
    return (await handler.retrieveQuestions());
  }

  @override
  void initState() {
    super.initState();
    chushihua();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "首页",
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: handler.retrieveQuestions(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<NoteModel>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[
                        Badge(
                          label: Text(
                            snapshot.data!.length.toString(),
                          ),
                          child: ListTile(
                            title: const Text('知识点'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const AddNotePage(),
                                    ),
                                  ),
                                ),
                                snapshot.data!.isNotEmpty
                                    ? IconButton(
                                        onPressed: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const StartReviewPage())),
                                        icon: const Icon(Icons.play_arrow),
                                      )
                                    : Container(),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const NoteListPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        const Text('Error'),
                      ];
                    } else {
                      children = <Widget>[
                        const SizedBox(
                          child: CircularProgressIndicator(),
                        )
                      ];
                    }
                    return Center(
                      child: Column(
                        children: children,
                      ),
                    );
                  },
                ),
                FutureBuilder(
                  future: thingsItem.retrieveThings(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TaskModel>> snapshot) {
                    List<Widget> children = [];
                    if (snapshot.hasData) {
                      children = <Widget>[
                        Badge(
                          label: Text(
                            snapshot.data!.length.toString(),
                          ),
                          child: ListTile(
                            title: const Text('事项'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const AddTaskPage(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const TaskListPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        Text('$snapshot'),
                      ];
                    } else {
                      children = <Widget>[
                        const SizedBox(
                          child: CircularProgressIndicator(),
                        )
                      ];
                    }
                    return Center(
                      child: Column(
                        children: children,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
