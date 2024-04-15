import 'package:flutter/material.dart';

import '../db/note_db.dart';
import '../model/note_model.dart';
import 'note_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(title: const Text('首页')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              child: FutureBuilder(
                future: handler.queryNote(),
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
                            await handler.deleteNote(snapshot.data![index].id!);
                            SnackBar snackbar = SnackBar(
                              content: const Text('已删除'),
                              action: SnackBarAction(
                                label: '撤销',
                                onPressed: () {
                                  setState(() {
                                    handler.insertNote(snapshot.data![index]);
                                  });
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                            await handler.deleteNote(snapshot.data![index].id!);
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
