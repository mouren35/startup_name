// lib/helpers/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:startup_namer/model/list_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_list.db');
    return await openDatabase(
      path,
      version: 2, // 升级数据库版本
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE todo_lists(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              parentListId INTEGER, 
              title TEXT)''',
        );
        db.execute(
          'CREATE TABLE todo_items(id INTEGER PRIMARY KEY AUTOINCREMENT, listId INTEGER, content TEXT, isCompleted INTEGER)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute(
            'ALTER TABLE todo_lists ADD COLUMN parentListId INTEGER',
          );
        }
      },
    );
  }

  Future<void> insertTodoList(TodoList list) async {
    final db = await database;
    await db.insert(
      'todo_lists',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoList>> getTodoLists({int? parentListId}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todo_lists',
      where: parentListId == null ? 'parentListId IS NULL' : 'parentListId = ?',
      whereArgs: parentListId == null ? [] : [parentListId],
    );

    return List.generate(maps.length, (i) {
      return TodoList(
        id: maps[i]['id'],
        parentListId: maps[i]['parentListId'],
        title: maps[i]['title'],
        items: [],
        subLists: [],
      );
    });
  }

  Future<void> insertTodoItem(TodoItem item) async {
    final db = await database;
    await db.insert(
      'todo_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoItem>> getTodoItems(int listId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todo_items',
      where: 'listId = ?',
      whereArgs: [listId],
    );

    return List.generate(maps.length, (i) {
      return TodoItem(
        id: maps[i]['id'],
        listId: maps[i]['listId'],
        content: maps[i]['content'],
        isCompleted: maps[i]['isCompleted'] == 1,
      );
    });
  }

  Future<void> updateTodoItem(TodoItem item) async {
    final db = await database;
    await db.update(
      'todo_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
