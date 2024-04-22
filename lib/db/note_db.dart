import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note_model.dart';

class NoteDb extends ChangeNotifier {
  static const id = 'id';
  static const title = 'title';
  static const answer = 'answer';
  static const status = 'state';

  Database? _db;

  Future<void> init() async {
    String path = await getDatabasesPath();
    _db = await openDatabase(
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
    notifyListeners();
  }

  Future<void> addNote(NoteModel noteModel) async {
    await _db?.insert('note', noteModel.toMap());
    notifyListeners();
  }

  Future<List<NoteModel>?> getNote() async {
    final List<Map<String, dynamic>>? queryResult = await _db?.query('note');
    return queryResult?.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<void> deleteNote(int id) async {
    await _db?.delete(
      'note',
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> update(NoteModel noteModel) async {
    await _db?.update(
      'note',
      noteModel.toMap(),
      where: 'id = ?',
      whereArgs: [noteModel.id],
    );
    notifyListeners();
  }
}
