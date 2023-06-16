import 'package:flutter/material.dart';
import 'package:startup_namer/Database/things.dart';
import 'package:startup_namer/Database/things_helper.dart';
import 'package:startup_namer/view/task_details.dart';
import 'time_starts.dart';

String currentTime = '';
var nowTime;

class ItemsList extends StatelessWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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

  @override
  void initState() {
    super.initState();
    thingItem = ThingsHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('事项'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Stack(
            children: [
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
                future: thingItem.retrieveThings(),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: const Icon(Icons.delete_forever),
                          ),
                          onDismissed: (DismissDirection direction) async {
                            await thingItem
                                .deleteThing(snapshot.data![index].id!);
                            SnackBar snackbar = SnackBar(
                              content: const Text('已删除'),
                              action: SnackBarAction(
                                label: '撤销',
                                onPressed: () {
                                  setState(() {
                                    thingItem
                                        .insertThing(snapshot.data![index]);
                                  });
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
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
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () {
                                      nowTime = DateTime.now();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            currentTime =
                                                snapshot.data![index].taskTime;

                                            return const TimeStarts();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TaskDetails(),
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          const Stack(
            children: [
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
                future: thingItem.retrieveThings(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Things>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Scrollbar(
                            child: SingleChildScrollView(
                          child: ListTile(
                            title: const Text('事项2'),
                            trailing: IconButton(
                              icon: const Icon(Icons.play_arrow),
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
