import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/db/task_db.dart';
import 'list_detail_page.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _listTitleController = TextEditingController();

  void _showAddListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('创建新清单'),
          content: TextField(
            controller: _listTitleController,
            decoration: const InputDecoration(hintText: '请输入清单标题'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _listTitleController.text.trim();
                if (title.isNotEmpty) {
                  Provider.of<TaskDB>(context, listen: false).addList(title);
                  _listTitleController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('创建'),
            ),
          ],
        );
      },
    );
  }

  void _deleteList(BuildContext context, int listId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除清单'),
          content: const Text('确认删除此清单吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<TaskDB>(context, listen: false).deleteList(listId);
                Navigator.of(context).pop();
              },
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('清单列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddListDialog(context),
          ),
        ],
      ),
      body: Consumer<TaskDB>(
        builder: (context, taskDB, child) {
          return FutureBuilder<List<Map<String, Object?>>?>(
            future: taskDB.getLists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('没有可用的清单'));
              } else {
                final lists = snapshot.data!;
                return ListView.builder(
                  itemCount: lists.length,
                  itemBuilder: (context, index) {
                    final list = lists[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(Icons.list, color: Colors.white),
                        ),
                        title: Text(list['title'] as String),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteList(context, list['id'] as int),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListDetailPage(
                                listId: list['id'] as int,
                                listTitle: list['title'] as String,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
