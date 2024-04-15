import 'package:flutter/material.dart';

import '../db/note_db.dart';
import '../model/note_model.dart';
import 'note_detail_page.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  late NoteDb handler;

  @override
  void initState() {
    super.initState();
    handler = NoteDb();
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
                    AsyncSnapshot<List<NoteModel>> snapshot) {
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
                                          const NoteDetailPage())));
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
