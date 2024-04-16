import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:startup_namer/pages/add_task_page.dart';
import 'package:startup_namer/pages/home_page.dart';
import 'package:startup_namer/util/navigator_util.dart';

import '../pages/add_note_page.dart';
import '../pages/tasks_list_page.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          TaskListPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          _bottomItem("首页", Icons.home, 0),
          _bottomItem("任务", Icons.list, 1),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        children: [
          _buildFab('添加任务', Icons.playlist_add_rounded, const AddTaskPage()),
          _buildFab('添加笔记', Icons.note_add_outlined, const AddNotePage())
        ],
      ),
    );
  }

  _bottomItem(String label, IconData icon, int index) {
    return NavigationDestination(
      icon: Icon(icon),
      label: label,
    );
  }

  _buildFab(String heroTag, IconData icon, Widget page) {
    return FloatingActionButton.small(
      heroTag: heroTag,
      tooltip: heroTag,
      onPressed: () {
        NavigatorUtil.push(context, page);
      },
      child: Icon(icon),
    );
  }
}
