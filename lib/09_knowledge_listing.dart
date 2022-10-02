import 'package:flutter/material.dart';
import 'package:startup_namer/Database/QuestionHelper.dart';
import 'package:startup_namer/Database/Questions.dart';
import '02_start_reviewing.dart';
import '11_knowledge_details.dart';

class KnowledgeListing extends StatelessWidget {
  const KnowledgeListing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowKnowledge(),
    );
  }
}

class ShowKnowledge extends StatefulWidget {
  ShowKnowledge({Key? key}) : super(key: key);

  @override
  State<ShowKnowledge> createState() => _ShowKnowledgeState();
}

class _ShowKnowledgeState extends State<ShowKnowledge> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      // await this.addQuestions();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            handler.retrieveQuestions();
            Navigator.of(context).pop();
          },
        ),
        title: const Text('知识点'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              child: FutureBuilder(
                future: this.handler.retrieveQuestions(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Question>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(Icons.delete_forever),
                          ),
                          key: UniqueKey(),
                          onDismissed: (DismissDirection direction) async {
                            Map deleteCashe = {
                              'index': index,
                            };

                            await handler
                                .deleteQuestion(snapshot.data![index].id!);
                            SnackBar snackbar = SnackBar(
                              content: Text('已删除'),
                              action: SnackBarAction(
                                label: '撤销',
                                onPressed: () {
                                  if (deleteCashe != null) {
                                    setState(() {
                                      handler.insertQuestions(
                                          snapshot.data![index]);
                                    });
                                  }
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                            await this
                                .handler
                                .deleteQuestion(snapshot.data![index].id!);
                            // setState(() {});
                          },
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) =>
                                          KnowledgeDetails())));
                                },
                                title: Text(snapshot.data![index].title),
                                subtitle: Text(snapshot.data![index].answer),
                              ),
                            ],
                          ),
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
            ),
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: MaterialButton(
          //         color: Color.fromARGB(255, 14, 75, 132),
          //         textColor: Colors.white,
          //         child: const Text('开始复习'),
          //         onPressed: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(builder: (context) => StartReviewing()),
          //           );
          //         },
          //       ),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}
