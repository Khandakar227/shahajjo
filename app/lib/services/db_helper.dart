import 'package:shahajjo/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/shahajjo.db';
    logger.i('DB Path: $path');
    // deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sos_contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phoneNumber TEXT,
        notificationEnabled INTEGER DEFAULT 1,
        smsEnabled INTEGER DEFAULT 0,
        created_at TEXT DEFAULT (DATETIME('now'))
      )
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> gets(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db
        .update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }
}
