import 'package:chinese_number/chinese_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:startup_namer/pages/review_page.dart';

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

  final dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 当天时间
        title: Text(
          '${dateTime.year}年${dateTime.month}月${dateTime.day + 1}日 星期${(dateTime.weekday + 1) == 7 ? "日" : (dateTime.weekday + 1).toSimplifiedChineseNumber()}',
        ),
      ),
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
          _bottomItem("首页", Icons.home_outlined, 0),
          _bottomItem("任务", Icons.list_alt_outlined, 1),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 60,
        type: ExpandableFabType.up,
        children: [
          _buildFab(Icons.playlist_add_rounded, const AddTaskPage()),
          _buildFab(Icons.note_add_outlined, const AddNotePage()),
          _buildFab(Icons.play_circle_outline, const ReviewPage()),
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
