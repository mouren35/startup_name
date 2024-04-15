import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/model/task_model.dart';

class TaskDB extends ChangeNotifier {
  static const id = 'id';
  static const title = 'title';
  static const note = 'note';
  static const steps = 'steps';
  static const taskTime = 'time';
  static const taskStatus = 'taskStatus';

  late Database _db;

  Future<void> init() async {
    String path = await getDatabasesPath();
    _db = await openDatabase(
      join(path, 'task.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE task($id INTEGER PRIMARY KEY AUTOINCREMENT,$title TEXT NOT NULL,$note TEXT NOT NULL,$steps TEXT NOT NULL,$taskTime TEXT NOT NULL,$taskStatus INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> addTask(TaskModel taskModel) async {
    await _db.insert('task', taskModel.toMap());
    notifyListeners();
  }

  Future<List<TaskModel>> getTask() async {
    final List<Map<String, Object?>> queryResult = await _db.query('task');
    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> deleteThing(int id) async {
    await _db.delete(
      'task',
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> updateTask(TaskModel taskModel) async {
    await _db.update(
      'task',
      taskModel.toMap(),
      where: 'id = ?',
      whereArgs: [taskModel.id],
    );
    notifyListeners();
  }
}
