import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/db/task_db.dart';
import 'package:startup_namer/model/task_model.dart';
import 'package:startup_namer/pages/task_detail_page.dart';
import 'package:startup_namer/widget/custom_appbar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<TaskModel>> _tasksByDate;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _tasksByDate = {};
    _loadTasks();
  }

  void _loadTasks() async {
    final provider = Provider.of<TaskDB>(context, listen: false);
    final tasks = await provider.getTask();

    setState(() {
      _tasksByDate = {};
      for (var task in tasks ?? []) {
        final taskDate = DateTime(
          task.taskTime!.year,
          task.taskTime!.month,
          task.taskTime!.day,
        );
        if (_tasksByDate[taskDate] == null) {
          _tasksByDate[taskDate] = [];
        }
        _tasksByDate[taskDate]!.add(task);
      }
    });
  }

  List<TaskModel> _getTasksForDay(DateTime day) {
    return _tasksByDate[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("日历"),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getTasksForDay,
            calendarStyle: CalendarStyle(
              markersMaxCount: 1,
            ),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    final tasks = _getTasksForDay(_selectedDay ?? _focusedDay);
    if (tasks.isEmpty) {
      return const Center(child: Text('这一天没有任务'));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
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
    );
  }
}
