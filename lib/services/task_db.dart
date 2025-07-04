import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

class TaskDB extends ChangeNotifier {
  static const id = 'id';
  static const title = 'title';
  static const note = 'note';
  static const steps = 'steps';
  static const taskDuration = 'time';
  static const taskStatus = 'taskStatus';
  static const createdAt = 'createdAt';
  static const taskColor = 'taskColor';
  static const repeatType = 'repeatType';
  static const repeatInterval = 'repeatInterval';
  static const listId = 'listId';

  Database? _db;

  Future<void> init() async {
    String path = await getDatabasesPath();
    _db = await openDatabase(
      join(path, 'task.db'),
      onCreate: (database, version) async {
        await database.execute("""
          CREATE TABLE task (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $title TEXT NOT NULL,
            $note TEXT,
            $steps TEXT,
            $taskDuration INTEGER NOT NULL,
            $taskStatus INTEGER,
            $createdAt TEXT NOT NULL,
            $taskColor INTEGER NOT NULL,
            $repeatType TEXT,
            $repeatInterval INTEGER,
            $listId INTEGER)""");
        await database.execute("""
          CREATE TABLE list (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $title TEXT NOT NULL)""");
      },
      version: 1,
    );
    notifyListeners();
  }

  Future<void> addTask(TaskModel taskModel) async {
    await _db?.insert('task', taskModel.toMap());
    notifyListeners();
  }

  Future<List<TaskModel>?> getTask() async {
    final List<Map<String, Object?>>? queryResult = await _db?.query('task');
    return queryResult?.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> deleteTask(int id) async {
    await _db?.delete(
      'task',
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> updateTask(int id, int newStatus) async {
    await _db?.update(
      'task',
      {'taskStatus': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }

    // 更新任务详情的方法
  Future<void> updateTaskDetails(TaskModel taskModel) async {
    await _db?.update(
      'task',
      taskModel.toMap(),
      where: 'id = ?',
      whereArgs: [taskModel.id],
    );
    notifyListeners();
  }

  Future<int> getCompletedTaskCount() async {
    final count = Sqflite.firstIntValue(
      await _db!.rawQuery('SELECT COUNT(*) FROM task WHERE taskStatus = 1'),
    );
    return count ?? 0;
  }

  Future<int> getTotalTaskCount() async {
    final count = Sqflite.firstIntValue(
      await _db!.rawQuery('SELECT COUNT(*) FROM task'),
    );
    return count ?? 0;
  }

  Future<Map<String, int>> getDailyTimeSpent() async {
    final result = await _db!.rawQuery(
      'SELECT DATE($createdAt) as date, SUM($taskDuration) as totalTime FROM task GROUP BY date',
    );
    return {for (var e in result) e['date'] as String: e['totalTime'] as int};
  }

  Future<List<TaskModel>> searchTasks(String query) async {
    final result = await _db!.query(
      'task',
      where: 'title LIKE ? OR note LIKE ? OR steps LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final allTasks = await getTask();
    if (allTasks == null) return [];

    List<TaskModel> tasksForSelectedDate = [];

    for (var task in allTasks) {
      DateTime taskDate = DateTime.parse(task.createdAt.toString());
      bool addTask = false;

      if (task.repeatType == '不重复') {
        addTask = isSameDay(taskDate, date);
      } else {
        while (taskDate.isBefore(date) || isSameDay(taskDate, date)) {
          if (isSameDay(taskDate, date)) {
            addTask = true;
            break;
          }
          switch (task.repeatType) {
            case '按天':
              taskDate = taskDate.add(Duration(days: task.repeatInterval));
              break;
            case '按周':
              taskDate = taskDate.add(Duration(days: 7 * task.repeatInterval));
              break;
            case '按月':
              taskDate = DateTime(taskDate.year,
                  taskDate.month + task.repeatInterval, taskDate.day);
              break;
          }
        }
      }

      if (addTask) {
        tasksForSelectedDate.add(task);
      }
    }

    return tasksForSelectedDate;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> addList(String title) async {
    await _db?.insert('list', {'title': title});
    notifyListeners();
  }

  Future<List<Map<String, Object?>>?> getLists() async {
    return await _db?.query('list');
  }

  Future<List<TaskModel>> getTasksByListId(int listId) async {
    final result = await _db!.query(
      'task',
      where: 'listId = ?',
      whereArgs: [listId],
    );
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<Map<Color, int>> getCompletedTasksByColor() async {
    final List<Map<String, Object?>> queryResult = await _db!.rawQuery(
      'SELECT taskColor, COUNT(*) as count FROM task WHERE taskStatus = 1 GROUP BY taskColor',
    );
    return {
      for (var e in queryResult) Color(e['taskColor'] as int): e['count'] as int
    };
  }

  Future<void> deleteList(int listId) async {
    await _db?.delete(
      'list',
      where: "id = ?",
      whereArgs: [listId],
    );
    notifyListeners();
  }
}
