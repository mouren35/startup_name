import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/task_model.dart';

class TaskDB extends ChangeNotifier {
  static const id = 'id';
  static const title = 'title';
  static const note = 'note';
  static const steps = 'steps';
  static const taskDuration = 'time';
  static const taskStatus = 'taskStatus';
  static const createdAt = 'createdAt';
  static const taskColor = 'taskColor'; // 新增颜色字段

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
            $taskColor INTEGER NOT NULL)""");
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
    return Map.fromIterable(result,
        key: (e) => e['date'] as String, value: (e) => e['totalTime'] as int);
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
    final result = await _db!.query(
      'task',
      where: 'DATE($createdAt) = ?',
      whereArgs: [date.toIso8601String().split('T').first],
    );
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }
}
