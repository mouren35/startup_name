import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/model/task_model.dart';

class TaskDB {
  static const id = 'id';
  static const title = 'title';
  static const note = 'note';
  static const steps = 'steps';
  static const taskTime = 'time';
  static const taskStatus = 'taskStatus';

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'task.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE task($id INTEGER PRIMARY KEY AUTOINCREMENT,$title TEXT NOT NULL,$note TEXT NOT NULL,$steps TEXT NOT NULL,$taskTime TEXT NOT NULL,$taskStatus INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertTask(TaskModel task) async {
    Database db = await initializeDB();
    return await db.insert('task', task.toMap());
  }

  Future<List<TaskModel>> queryTask() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('task');
    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }

  changeState() async {
    Database db = await initializeDB();
    db.update('task', {taskStatus: 1});
  }

  Future<void> deleteThing(int id) async {
    final db = await initializeDB();
    await db.delete(
      'task',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateThing(TaskModel thing) async {
    final db = await initializeDB();
    await db.update(
      'task',
      thing.toMap(),
      where: 'id = ?',
      whereArgs: [thing.id],
    );
  }
}
