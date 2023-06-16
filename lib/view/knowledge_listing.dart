import 'package:flutter/material.dart';
import 'package:startup_namer/Database/question_helper.dart';
import 'package:startup_namer/Database/questions.dart';
import 'package:startup_namer/view/knowledge_details.dart';

class KnowledgeListing extends StatelessWidget {
  const KnowledgeListing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ShowKnowledge(),
    );
  }
}

class ShowKnowledge extends StatefulWidget {
  const ShowKnowledge({Key? key}) : super(key: key);

  @override
  State<ShowKnowledge> createState() => _ShowKnowledgeState();
}

class _ShowKnowledgeState extends State<ShowKnowledge> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
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
                future: handler.retrieveQuestions(),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: const Icon(Icons.delete_forever),
                          ),
                          key: UniqueKey(),
                          onDismissed: (DismissDirection direction) async {
                            await handler
                                .deleteQuestion(snapshot.data![index].id!);
                            SnackBar snackbar = SnackBar(
                              content: const Text('已删除'),
                              action: SnackBarAction(
                                label: '撤销',
                                onPressed: () {
                                  setState(() {
                                    handler
                                        .insertQuestions(snapshot.data![index]);
                                  });
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                            await handler
                                .deleteQuestion(snapshot.data![index].id!);
                          },
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) =>
                                          const KnowledgeDetails())));
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
