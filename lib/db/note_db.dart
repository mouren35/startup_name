import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/model/note_model.dart';

class NoteDb {
  static const id = 'id';
  static const title = 'title';
  static const answer = 'answer';
  static const status = 'state';

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'note.db'),
      onCreate: (database, version) async {
        await database.execute("""
          CREATE TABLE note (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $title TEXT NOT NULL,
            $answer TEXT NOT NULL)""");
      },
      version: 1,
    );
  }

  Future<int> insertNote(NoteModel note) async {
    Database db = await initializeDB();
    return await db.insert('note', note.toMap());
  }

  Future<List<NoteModel>> queryNote() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('note');
    return queryResult.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<void> deleteNote(int id) async {
    final db = await initializeDB();
    await db.delete('note', where: "id = ?", whereArgs: [id]);
  }
}
