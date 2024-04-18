import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../pages/add_note_page.dart';
import '../pages/add_task_page.dart';
import '../pages/home_page.dart';
import '../pages/tasks_list_page.dart';
import '../util/navigator_util.dart';

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
        distance: 60,
        type: ExpandableFabType.up,
        children: [
          _buildFab(Icons.playlist_add_rounded, AddTaskPage()),
          _buildFab(Icons.note_add_outlined, const AddNotePage())
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

  _buildFab(IconData icon, Widget page) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () {
        NavigatorUtil.push(context, page);
      },
      child: Icon(icon),
    );
  }
}
