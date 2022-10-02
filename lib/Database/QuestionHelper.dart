import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:startup_namer/Database/Questions.dart';

class DatabaseHandler {
  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnAnswer = 'answer';
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

  Future<int> insertQuestions(Question question) async {
    Database db = await initializeDB();
    return await db.insert('questions', question.toMap());
  }

  Future<List<Question>> retrieveQuestions() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'questions',
      // columns: [columnId, columnAnswer, columnTitle],
      // where: '$columnId = ?',
      // whereArgs: [id]
    );
    return queryResult.map((e) => Question.fromMap(e)).toList();
  }

  // Future<Question?> retrieveQuestions(int id) async {
  //   final Database db = await initializeDB();
  //   final List<Map<String, Object?>> queryResult = await db.query('questions',
  //       columns: [columnId, columnAnswer, columnTitle],
  //       where: '$columnId = ?',
  //       whereArgs: [id]);
  //   if (queryResult.length > 0) {
  //     return Question.fromMap(queryResult.first);
  //   }
  //   return null;
  // }

  Future<void> deleteQuestion(int id) async {
    final db = await initializeDB();
    await db.delete(
      'questions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
