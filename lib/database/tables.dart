import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//class helper database
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dKir.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dzikir(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       title TEXT,
       target INTEGER,
       reminder TEXT
      )''');

    print('table dzikir created');
  }

  Future<void> insertDzikir(String title, int target, String reminder) async {
    final db = await database;
    await db.insert('dzikir', {
      'title': title,
      'target': target,
      'reminder': reminder,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    print('New dzikir inserted');
  }

  Future<List<Map<String, dynamic>>> getDzikir() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('dzikir');
    return result;
  }

  Future<void> updateDzikir(
    int id,
    String title,
    int target,
    String reminder,
  ) async {
    final db = await database;
    await db.update(
      'dzikir',
      {'title': title, 'target': target, 'reminder': reminder},
      where: 'id = ?',
      whereArgs: [id],
    );
    print('dzikir updated');
  }
}
