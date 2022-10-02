import 'dart:developer';

import 'package:flutter/material.dart';
import '06_time_starts.dart';
import 'Database/ThingsHelper.dart';
import 'Database/Things.dart';
import '10_task_details.dart';

String currentTime = '';
var nowTime;

class ItemsList extends StatelessWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Items(),
    );
  }
}

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  late ThingsHandler thingItem;
  // late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.thingItem = ThingsHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            // handler.retrieveQuestions();
          },
        ),
        title: const Text('事项'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            children: const [
              ListTile(
                title: Text(
                  '未完成',
                  textScaleFactor: 1.5,
                ),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              child: FutureBuilder(
                future: this.thingItem.retrieveThings(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Things>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(Icons.delete_forever),
                          ),
                          onDismissed: (DismissDirection direction) async {
                            Map deleteCashe = {
                              'index': index,
                            };

                            await thingItem
                                .deleteThing(snapshot.data![index].id!);
                            SnackBar snackbar = SnackBar(
                              content: Text('已删除'),
                              action: SnackBarAction(
                                label: '撤销',
                                onPressed: () {
                                  if (deleteCashe != null) {
                                    setState(() {
                                      thingItem
                                          .insertThing(snapshot.data![index]);
                                    });
                                  }
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                            // setState(() {});
                          },
                          key: UniqueKey(),
                          child: Column(
                            children: [
                              Scrollbar(
                                  child: SingleChildScrollView(
                                child: ListTile(
                                  leading: Text(snapshot.data![index].taskTime),
                                  title: Text(snapshot.data![index].title),
                                  subtitle: Text(
                                      snapshot.data![index].note.toString()),
                                  trailing: IconButton(
                                    icon: Icon(Icons.play_arrow),
                                    onPressed: () {
                                      nowTime = DateTime.now();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            currentTime =
                                                snapshot.data![index].taskTime;
                                            // log(currentTime);
                                            return const TimeStarts();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => TaskDetails(),
                                      ),
                                    );
                                  },
                                ),
                              ))
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
          Stack(
            children: const [
              ListTile(
                title: Text(
                  '已完成',
                  textScaleFactor: 1.5,
                ),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              child: FutureBuilder(
                future: this.thingItem.retrieveThings(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Things>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Scrollbar(
                            child: SingleChildScrollView(
                          child: ListTile(
                            title: Text('事项2'),
                            trailing: IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const TimeStarts(),
                                  ),
                                );
                              },
                            ),
                            onTap: () {},
                          ),
                        ));
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
        ],
      ),
    );
  }
}
