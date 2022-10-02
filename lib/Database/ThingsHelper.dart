import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:startup_namer/Database/Things.dart';

class ThingsHandler {
  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnNote = 'note';
  static final columnSteps = 'steps';
  static final columnTasktime = 'time';
  static final columnTaskStatus = 'taskStatus';

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'things.db'),
      onCreate: (database, version) async {
        await database.execute(
          // 时间类型可能有错
          'CREATE TABLE things($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnTitle TEXT NOT NULL,$columnNote TEXT NOT NULL,$columnSteps TEXT NOT NULL,$columnTasktime TEXT NOT NULL,$columnTaskStatus INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertThing(Things thing) async {
    Database db = await initializeDB();
    return await db.insert('things', thing.toMap());
  }

  Future<List<Things>> retrieveThings() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('things');
    return queryResult.map((e) => Things.fromMap(e)).toList();
  }

  changeState() async {
    Database db = await initializeDB();
    db.update('things', {columnTaskStatus: 1});
    // db.rawUpdate(sql)
  }

  Future<void> deleteThing(int id) async {
    final db = await initializeDB();
    await db.delete(
      'things',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateThing(Things thing) async {
    final db = await initializeDB();
    await db.update(
      'things',
      thing.toMap(),
      where: 'id = ?',
      whereArgs: [thing.id],
    );
  }
}
