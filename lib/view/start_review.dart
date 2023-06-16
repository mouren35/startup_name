import 'package:flutter/material.dart';
import 'package:startup_namer/Database/question_helper.dart';
import 'package:startup_namer/Database/questions.dart';

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

  bool knowAnswer = false;
  int? global;
  DatabaseHandler handler = DatabaseHandler();
  List dataList = [];
  List queryData = [];

  void chushihua() async {
    final queryData = await handler.retrieveQuestions();
    setState(() {
      dataList = queryData;
    });
  }

  void downShowAgain(bool knowAnswer, int global) {
    if (knowAnswer) {
      handler.deleteQuestion(global);
    }
  }

  @override
  void initState() {
    super.initState();
    chushihua();
    handler.initializeDB().whenComplete(() async {
      setState(() {
        dataList = queryData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: handler.retrieveQuestions(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Question>> snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = i < dataList.length
                            ? [
                                Text(
                                  snapshot.data![i].title,
                                )
                              ]
                            : [
                                const Center(
                                  child: Text('复习完成啦！'),
                                )
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
                      ));
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(
                    height: 5.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  showAnswer
                      ? FutureBuilder(
                          future: handler.retrieveQuestions(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Question>> snapshot) {
                            List<Widget> children;

                            if (snapshot.hasData) {
                              global = snapshot.data![i].id;
                              children = <Widget>[
                                Text(
                                  snapshot.data![i].answer,
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
                        )
                      : const Text(''),
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
                        color: Colors.red[400],
                        textColor: Colors.white,
                        child: const Text(
                          '不熟悉/不知道',
                        ),
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
                        color: Colors.green,
                        textColor: Colors.white,
                        child: const Text(
                          '熟悉',
                        ),
                      ),
                    ),
                  ],
                )
              : (i < dataList.length
                  ? MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () {
                        setState(() {
                          showAnswer = !showAnswer;
                        });
                      },
                      color: const Color.fromARGB(255, 14, 75, 132),
                      textColor: Colors.white,
                      child: const Text(
                        '显示答案',
                      ),
                    )
                  : MaterialButton(
                      color: Colors.blue[400],
                      textColor: Colors.white,
                      minWidth: double.infinity,
                      onPressed: () {
                        setState(() {
                          i = 0;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '返回',
                      ),
                    )),
        ],
      ),
    );
  }
}
