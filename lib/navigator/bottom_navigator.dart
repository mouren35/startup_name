import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/pages/home_page.dart';
import 'package:startup_namer/provider/note_provider.dart';
import 'package:startup_namer/provider/task_provider.dart';

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
        children: [
          ChangeNotifierProvider(
            create: (context) => NoteProvider(),
            child: const HomePage(),
          ),
          ChangeNotifierProvider(
            create: (context) => TaskProvider(),
            child: const TaskListPage(),
          )
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
    );
  }

  _bottomItem(String label, IconData icon, int index) {
    return NavigationDestination(
      icon: Icon(icon),
      label: label,
    );
  }
}
