import 'package:flutter/material.dart';
import 'Database/QuestionHelper.dart';
import 'Database/Questions.dart';
// import '04_add_notes.dart';

class StartReviewing extends StatelessWidget {
  const StartReviewing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int i = 0;
  bool showAnswer = false;
  // 熟不熟悉
  bool knowAnswer = false;
  int? global;
  DatabaseHandler handler = DatabaseHandler();
  List data_list = [];
  List query_data = [];

  void chushihua() async {
    final queryData = await handler.retrieveQuestions();
    setState(() {
      data_list = queryData;
    });
  }

  void downShowAgain(bool knowAnswer, int global) {
    if (knowAnswer) {
      handler.deleteQuestion(global);
    }
  }

  @override
  void initState() {
    // late Future<List<Question>> data_list;
    super.initState();
    chushihua();
    handler.initializeDB().whenComplete(() async {
      setState(() {
        data_list = query_data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // var a = i / data_list.length;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('复习'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          )
        ],
        elevation: 0,
      ),
      body: Column(
        // 滚动界面下，使按钮始终处于底部
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // LinearProgressIndicator(
                  //   color: Colors.orange,
                  //   value: 0 + i / data_list.length,
                  // ),
                  // Text('${data_list.length}'),
                  // 数据显示
                  FutureBuilder(
                    future: this.handler.retrieveQuestions(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Question>> snapshot) {
                      var children;
                      if (snapshot.hasData) {
                        children = i < data_list.length
                            ? [
                                Text(
                                  snapshot.data![i].title,
                                )
                              ]
                            : [
                                Center(
                                  child: Text('复习完成啦！'),
                                )
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
                      ));
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  showAnswer
                      ? FutureBuilder(
                          future: this.handler.retrieveQuestions(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Question>> snapshot) {
                            // global = snapshot.data![i].id!;
                            List<Widget> children;

                            if (snapshot.hasData) {
                              global = snapshot.data![i].id;
                              print("global: " + global.toString());
                              // downShowAgain();
                              children = <Widget>[
                                Text(
                                  snapshot.data![i].answer,
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
                        )
                      : Text(''),
                ],
              ),
            ),
          ),
          showAnswer
              ? Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        height: 70,
                        onPressed: () {
                          setState(() {
                            i++;
                            showAnswer = !showAnswer;
                          });
                        },
                        child: Text(
                          '不熟悉/不知道',
                        ),
                        color: Colors.red[400],
                        textColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        height: 70,
                        onPressed: () {
                          setState(() {
                            i++;
                            showAnswer = !showAnswer;
                            knowAnswer = !knowAnswer;
                            downShowAgain(knowAnswer, global!);
                            knowAnswer = false;
                          });
                        },
                        child: Text(
                          '熟悉',
                        ),
                        color: Colors.green,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                )
              : (i < data_list.length
                  ? MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () {
                        setState(() {
                          // i++;
                          showAnswer = !showAnswer;
                        });
                      },
                      child: Text(
                        '显示答案',
                      ),
                      color: Color.fromARGB(255, 14, 75, 132),
                      textColor: Colors.white,
                    )
                  : MaterialButton(
                      child: Text(
                        '返回',
                      ),
                      color: Colors.blue[400],
                      textColor: Colors.white,
                      minWidth: double.infinity,
                      onPressed: () {
                        setState(() {
                          i = 0;
                        });
                        Navigator.pop(context);
                      },
                    )),
        ],
      ),
    );
  }
}
