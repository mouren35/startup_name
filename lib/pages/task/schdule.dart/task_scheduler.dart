import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:startup_namer/model/task_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TaskScheduler {
  static final TaskScheduler _instance = TaskScheduler._internal();

  factory TaskScheduler() {
    return _instance;
  }

  TaskScheduler._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleTask(TaskModel task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      _nextInstanceOfTask(task),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: _matchDateTimeComponents(task),
    );
  }

  tz.TZDateTime _nextInstanceOfTask(TaskModel task) {
    final now = tz.TZDateTime.now(tz.local);

    switch (task.repeatType) {
      case '按天':
        return tz.TZDateTime(tz.local, now.year, now.month,
            now.day + task.repeatInterval, now.hour, now.minute);
      case '按周':
        return now.add(Duration(days: 7 * task.repeatInterval));
      case '按月':
        return tz.TZDateTime(tz.local, now.year,
            now.month + task.repeatInterval, now.day, now.hour, now.minute);
      default:
        return now;
    }
  }

  DateTimeComponents _matchDateTimeComponents(TaskModel task) {
    switch (task.repeatType) {
      case '按天':
        return DateTimeComponents.time;
      case '按周':
        return DateTimeComponents.dayOfWeekAndTime;
      case '按月':
        return DateTimeComponents.dayOfMonthAndTime;
      default:
        return DateTimeComponents.time;
    }
  }
}
