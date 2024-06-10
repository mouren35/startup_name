import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/db/task_db.dart';
import 'package:startup_namer/model/task_model.dart';
import 'package:startup_namer/pages/task_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<TaskModel>? _searchResults;

  void _performSearch(String query) async {
    final provider = Provider.of<TaskDB>(context, listen: false);
    final results = await provider.searchTasks(query);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '请输入搜索关键词',
            // 隐藏border
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            // 设置背景色为透明
            filled: true,
            fillColor: Colors.transparent,
            // 添加清除按钮
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, size: 16),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _performSearch(_searchController.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _searchResults == null
                  ? const Center(child: Text('请输入搜索关键词'))
                  : _searchResults!.isEmpty
                      ? const Center(child: Text('未找到相关任务'))
                      : ListView.builder(
                          itemCount: _searchResults!.length,
                          itemBuilder: (context, index) {
                            final task = _searchResults![index];
                            return ListTile(
                              title: Text(task.title),
                              subtitle: Text(task.note ?? '无备注'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailPage(
                                      title: task.title,
                                      time: task.taskDuration!,
                                      step: task.steps ?? '',
                                      note: task.note ?? '',
                                      id: task.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
