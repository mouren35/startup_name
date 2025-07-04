import "package:startup_namer/core/constants.dart";
import 'package:flutter/material.dart';
import 'package:startup_namer/services/task_db.dart';
import 'package:startup_namer/models/task_model.dart';
import 'package:startup_namer/pages/task/task_detail_page.dart';
import 'package:startup_namer/utils/navigator_util.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  ValueNotifier<List<TaskModel>>? _selectedTasks;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedTasks = ValueNotifier([]);
    _loadTasksForSelectedDay();
  }

  void _loadTasksForSelectedDay() async {
    final taskDB = Provider.of<TaskDB>(context, listen: false);
    final tasks = await taskDB.getTasksByDate(_selectedDay!);
    _selectedTasks?.value = tasks;
  }

  @override
  void dispose() {
    _selectedTasks?.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _loadTasksForSelectedDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日历'),
      ),
      body: Column(
        children: [
          TableCalendar<TaskModel>(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: (day) => [], // 不再使用 eventLoader 加载任务
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<TaskModel>>(
              valueListenable: _selectedTasks!,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color:
                            value[index].taskColor.withOpacity(0.3), // 使用颜色属性
                        border: Border.all(
                          color: value[index].taskColor, // 使用颜色属性
                        ),
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                      child: ListTile(
                        onTap: () => NavigatorUtil.push(
                          context,
                          TaskDetailPage(
                            title: value[index].title,
                            time: value[index].taskDuration!,
                            step: value[index].steps ?? '',
                            note: value[index].note ?? '',
                            id: value[index].id,
                          ),
                        ),
                        title: Text(value[index].title),
                        subtitle: Text(value[index].note ?? ''),
                        
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
