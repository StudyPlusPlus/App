import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._constructor();

  DataBaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;

    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");

    _db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            user_id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE tasks (
            task_id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            start_date TEXT,
            end_date TEXT,
            total_days INTEGER,
            priority TEXT,
            status INTEGER DEFAULT 0,
            created_by INTEGER,
            FOREIGN KEY (created_by) REFERENCES users (user_id)
          )
        ''');

        await db.execute('''
          CREATE TABLE task_progress (
            progress_id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            progress_percentage REAL CHECK (progress_percentage BETWEEN 0 AND 100),
            FOREIGN KEY (task_id) REFERENCES tasks (task_id)
          )
        ''');

        await db.execute('''
          CREATE TABLE task_users (
            task_id INTEGER NOT NULL,
            user_id INTEGER NOT NULL,
            role TEXT,
            PRIMARY KEY (task_id, user_id),
            FOREIGN KEY (task_id) REFERENCES tasks (task_id),
            FOREIGN KEY (user_id) REFERENCES users (user_id)
          )
        ''');
      },
    );
    return _db!;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

   Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<List<Map<String, dynamic>>> getTaskProgress() async {
    final db = await database;
    return await db.query('tasks_progress');
  }

  Future<List<Map<String, dynamic>>> getTaskUser() async {
    final db = await database;
    return await db.query('task_users');
  }

  Future<void> insertTask(String title, String description, String startTime, String endTime, String priority, bool alert) async {
    final db = await database;
    await db.insert('tasks', {
      'title': title,
      'description': description,
      'start_date': startTime,
      'end_date': endTime,
      'priority': priority,
      'total_days': 1, 
      'status': 0, 
    });
  }



}
