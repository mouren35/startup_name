import 'package:flutter/material.dart';
import 'package:startup_namer/Database/Things.dart';
import 'package:startup_namer/Database/ThingsHelper.dart';
import '09_knowledge_listing.dart';
import '08_items_list.dart';
import 'package:badges/badges.dart';
import '04_add_notes.dart';
import '05_add_tasks.dart';
import '02_start_reviewing.dart';
import 'Database/QuestionHelper.dart';
import 'Database/Questions.dart';

void main(List<String> args) {
  runApp(const KnowledgeTime());
}

class KnowledgeTime extends StatelessWidget {
  const KnowledgeTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "知时",
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 242, 240, 227),
        // primaryColor: Color.fromRGBO(240, 240, 226, 0),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 242, 240, 227),
          onPrimary: Colors.black,
          secondary: Color.fromARGB(255, 14, 75, 132),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.yellow,
          background: Color.fromARGB(255, 242, 240, 227),
          onBackground: Colors.black,
          surface: Color.fromARGB(255, 242, 240, 227),
          onSurface: Colors.black,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHandler handler = DatabaseHandler();
  ThingsHandler thingsItem = ThingsHandler();
  List data_list = [];
  List queryData = [];

  Future<List<dynamic>> chushihua() async {
    queryData = await handler.retrieveQuestions();
    return (await handler.retrieveQuestions());
    // setState(() {
    //   data_list = queryData;
    //   return queryData;
    // });
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
          // style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
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
                          badgeContent: Text(
                            snapshot.data!.length.toString(),
                            style: TextStyle(color: Colors.white),
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
                                snapshot.data!.length != 0
                                    ? IconButton(
                                        onPressed: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    StartReviewing())),
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
                        Text('Error'),
                      ];
                    } else {
                      children = <Widget>[
                        SizedBox(
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
                          badgeContent: Text(
                            snapshot.data!.length.toString(),
                            style: TextStyle(color: Colors.white),
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
                        SizedBox(
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
          Row(
            children: [
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        handler.retrieveQuestions();
                        thingsItem.retrieveThings();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                  onPressed: () {
                    setState(() {
                      handler.retrieveQuestions();
                      thingsItem.retrieveThings();
                    });
                  },
                ),
              ),
            ],
          ),

          // Column(
          //   children: [
          //     // Expanded(child: Container()),

          //   ],
          // ),
        ],
      ),
    );
  }
}
