import 'package:flutter/material.dart';
import 'package:startup_namer/Database/things.dart';
import 'package:startup_namer/Database/things_helper.dart';
import 'package:startup_namer/view/add_notes.dart';
import 'package:startup_namer/view/add_tasks.dart';
import 'package:startup_namer/view/items_list.dart';
import 'package:startup_namer/view/knowledge_listing.dart';
import 'package:startup_namer/view/start_review.dart';
import 'Database/question_helper.dart';
import 'Database/questions.dart';

void main(List<String> args) {
  runApp(const KnowledgeTime());
}

class KnowledgeTime extends StatelessWidget {
  const KnowledgeTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "xxx",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHandler handler = DatabaseHandler();
  ThingsHandler thingsItem = ThingsHandler();
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
                      AsyncSnapshot<List<Question>> snapshot) {
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
                                      builder: (context) => const AddNotes(),
                                    ),
                                  ),
                                ),
                                snapshot.data!.isNotEmpty
                                    ? IconButton(
                                        onPressed: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const StartReviewing())),
                                        icon: const Icon(Icons.play_arrow),
                                      )
                                    : Container(),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const KnowledgeListing(),
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
                      AsyncSnapshot<List<Things>> snapshot) {
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
                                      builder: (context) => const AddTasks(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ItemsList(),
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
