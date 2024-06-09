import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/model/post_comment_mo.dart';
import 'package:startup_namer/model/post_mo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'forum.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id TEXT PRIMARY KEY,
        username TEXT,
        dateTime TEXT,
        title TEXT,
        content TEXT,
        likes INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE comments (
        id TEXT PRIMARY KEY,
        postId TEXT,
        username TEXT,
        dateTime TEXT,
        content TEXT,
        FOREIGN KEY (postId) REFERENCES posts (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE posts ADD COLUMN title TEXT');
      await db
          .execute('UPDATE posts SET title = "Untitled" WHERE title IS NULL');
      await db.execute(
          'CREATE TABLE new_posts AS SELECT id, username, dateTime, title, content, likes FROM posts');
      await db.execute('DROP TABLE posts');
      await db.execute('ALTER TABLE new_posts RENAME TO posts');
    }
  }

  Future<void> insertPost(Post post) async {
    final db = await database;
    await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Post>> getPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posts');

    List<Post> posts = List.generate(maps.length, (i) {
      return Post(
        id: maps[i]['id'],
        username: maps[i]['username'],
        dateTime: DateTime.parse(maps[i]['dateTime']),
        title: maps[i]['title'] ?? 'Untitled',
        content: maps[i]['content'],
        likes: maps[i]['likes'], avatarUrl: '',
      );
    });

    for (Post post in posts) {
      post.comments = await getComments(post.id);
    }

    return posts;
  }

  Future<void> insertComment(Comment comment) async {
    final db = await database;
    await db.insert(
      'comments',
      comment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Comment>> getComments(String postId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'comments',
      where: 'postId = ?',
      whereArgs: [postId],
    );

    return List.generate(maps.length, (i) {
      return Comment(
        id: maps[i]['id'],
        username: maps[i]['username'],
        dateTime: DateTime.parse(maps[i]['dateTime']),
        content: maps[i]['content'], postId: '',
      );
    });
  }

  Future<void> updateLikes(String postId, int likes) async {
    final db = await database;
    await db.update(
      'posts',
      {'likes': likes},
      where: 'id = ?',
      whereArgs: [postId],
    );
  }

  Future<void> deletePost(String postId) async {
    final db = await database;
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [postId],
    );
  }
}
