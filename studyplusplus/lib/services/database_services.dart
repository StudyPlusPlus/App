import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._constructor();

  DataBaseService._constructor();

  Future<Database> get tableUsers() async {
    _db.query(table)
  }
  

  Future<Database> getUsers() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users (
            user_id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL
          )
        ''');
      },
    );
    return database;
  }

  Future<Database> getTasks() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE tasks (
            task_id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            start_date TEXT,
            end_date TEXT,
            total_days INTEGER,
            status INTEGER DEFAULT 0,
            created_by INTEGER,
            FOREIGN KEY (created_by) REFERENCES users (user_id)
        )
        ''');
      },
    );
    return database;
  }

  Future<Database> getTaskProgress() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
         CREATE TABLE task_progress (
            progress_id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            progress_percentage REAL CHECK (progress_percentage BETWEEN 0 AND 100),
            FOREIGN KEY (task_id) REFERENCES tasks (task_id)
          ) 
        ''');
      },
    );
    return database;
  }

  Future<Database> getTaskUsers() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
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
    return database;
  }
}
