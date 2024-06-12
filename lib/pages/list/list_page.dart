import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/db/task_db.dart';
import 'add_list_page.dart';
import 'list_detail_page.dart'; // 引入清单详情页

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('清单列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddListPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, Object?>>?>(
        future: provider.getLists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('没有可用的清单'));
          }

          final lists = snapshot.data!;
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return ListTile(
                title: Text(list['title'] as String),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListDetailPage(
                        listId: list['id'] as int,
                        listTitle: list['title'] as String,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
