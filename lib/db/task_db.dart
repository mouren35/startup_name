import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/model/task_model.dart';

class TaskDB {
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnNote = 'note';
  static const columnSteps = 'steps';
  static const columnTasktime = 'time';
  static const columnTaskStatus = 'taskStatus';

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'things.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE things($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnTitle TEXT NOT NULL,$columnNote TEXT NOT NULL,$columnSteps TEXT NOT NULL,$columnTasktime TEXT NOT NULL,$columnTaskStatus INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertThing(TaskModel thing) async {
    Database db = await initializeDB();
    return await db.insert('things', thing.toMap());
  }

  Future<List<TaskModel>> retrieveThings() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('things');
    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }

  changeState() async {
    Database db = await initializeDB();
    db.update('things', {columnTaskStatus: 1});
  }

  Future<void> deleteThing(int id) async {
    final db = await initializeDB();
    await db.delete(
      'things',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateThing(TaskModel thing) async {
    final db = await initializeDB();
    await db.update(
      'things',
      thing.toMap(),
      where: 'id = ?',
      whereArgs: [thing.id],
    );
  }
}
