import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:startup_namer/pages/post/post_main_page.dart';

import 'package:startup_namer/pages/task/stats_page.dart';

import '../pages/add_note_page.dart';
import '../pages/add_task_page.dart';
import '../pages/note_list_page.dart';
import '../pages/tasks_list_page.dart';
import '../util/navigator_util.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TaskListPage(),
          NoteListPage(),
          PostMainPage(),
          TaskStatisticsPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.list_alt_outlined),
          label: '任务',
        ),
        NavigationDestination(
          icon: Icon(Icons.edit_note_rounded),
          label: '笔记',
        ),
        NavigationDestination(
          icon: Icon(Icons.forum_outlined),
          label: '树洞',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart),
          label: '统计',
        ),
      ],
    );
  }

  void _onDestinationSelected(int index) {
    _controller.jumpToPage(index);
  }

  Widget _buildFab(IconData icon, Widget page) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () {
        NavigatorUtil.push(context, page);
      },
      child: Icon(icon),
    );
  }
}
