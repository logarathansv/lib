import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_auth.db');
    return openDatabase(path, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT, password TEXT)',
      );
    }, version: 1);
  }

  // Insert a dummy user for testing
  Future<void> insertUser(String email, String password) async {
    final db = await database;
    await db.insert('users', {'email': email, 'password': password});
  }

  // Authenticate user
  Future<bool> authenticate(String email, String password) async {
    final db = await database;
    var result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
}
