import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/util/navigator_util.dart';
import 'package:startup_namer/widget/show_snack_bar.dart';

import '../db/note_db.dart';
import '../model/note_model.dart';
import 'note_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteDb>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              child: FutureBuilder(
                future: provider.getNote(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<NoteModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final data = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: const Icon(Icons.delete_forever),
                        ),
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) async {
                          await provider.deleteNote(data[index].id!);
                          showSnackBar(
                            context,
                            '删除成功',
                            '撤销',
                            () => provider.addNote(data[index]),
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                NavigatorUtil.push(
                                  context,
                                  const NoteDetailPage(),
                                );
                              },
                              title: Text(data[index].title),
                              subtitle: Text(data[index].answer),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
