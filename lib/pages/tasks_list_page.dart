import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/pages/add_task_page.dart';
import 'package:startup_namer/pages/task/search/search_page.dart';
import 'package:startup_namer/pages/task/stats_page.dart';
import 'package:startup_namer/util/navigator_util.dart';
import 'package:startup_namer/widget/custom_appbar.dart';
import 'package:startup_namer/widget/post/user_avatar.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';
import '../widget/task_expansion_tile.dart';

class TaskListPage extends StatefulWidget {
  final User user;
  const TaskListPage({Key? key, required this.user}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the bottom of the list, load more data
      Provider.of<TaskDB>(context, listen: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return FutureBuilder<List<TaskModel>?>(
      future: provider.getTask(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<TaskModel>?> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data;
        final undoTask = data?.where((task) => task.taskStatus == 0).toList();
        final completedTask =
            data?.where((task) => task.taskStatus == 1).toList();

        return Scaffold(
          appBar: CustomAppBar(
            actions: [
              const Icon(Icons.add),
              const Icon(Icons.search),
              const Icon(Icons.bar_chart_rounded),
              UserAvatar(email: widget.user.email!),
            ],
            onActionPressed: [
              () {
                NavigatorUtil.push(context, const AddTaskPage());
              },
              () {
                NavigatorUtil.push(context, const SearchPage());
              },
              () {
                NavigatorUtil.push(context, StatisticsPage());
              },
              () {}
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                TaskExpansionTile(
                  title: '未完成',
                  tasks: undoTask ?? [],
                ),
                TaskExpansionTile(
                  title: '完成',
                  tasks: completedTask ?? [],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
