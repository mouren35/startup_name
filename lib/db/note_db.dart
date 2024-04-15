import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/model/note_model.dart';

class NoteDb {
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnAnswer = 'answer';
  static const columnState = 'state';

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'questions.db'),
      onCreate: (database, version) async {
        await database.execute("""
          CREATE TABLE questions (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnAnswer TEXT NOT NULL)""");
      },
      version: 1,
    );
  }

  Future<int> insertQuestions(NoteModel question) async {
    Database db = await initializeDB();
    return await db.insert('questions', question.toMap());
  }

  Future<List<NoteModel>> retrieveQuestions() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'questions',
    );
    return queryResult.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<void> deleteQuestion(int id) async {
    final db = await initializeDB();
    await db.delete(
      'questions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
