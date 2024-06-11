import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:startup_namer/model/habit_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'habits.db');

    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE habits(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT, 
              description TEXT, 
              frequency TEXT, 
              completed INTEGER)''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    await db.insert('habits', habit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Habit>> habits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');

    return List.generate(maps.length, (i) {
      return Habit(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        frequency: maps[i]['frequency'],
        completed: maps[i]['completed'] == 1,
      );
    });
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update('habits', habit.toMap(),
        where: 'id = ?', whereArgs: [habit.id]);
  }

  Future<void> deleteHabit(int id) async {
    final db = await database;
    await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }
}
