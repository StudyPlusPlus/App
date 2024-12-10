import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._constructor();
  Map<String, dynamic>? _currentUser;

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
            email TEXT UNIQUE NOT NULL,
            profile_picture TEXT
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

  Future<void> insertTask(String title, String description, String startTime,
      String endTime, String priority, bool alert) async {
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

  Future<void> insertUser(
      String username, String password, String email) async {
    final db = await database;
    await db.insert('users', {
      'username': username,
      'password': password,
      'email': email,
    });
  }

  Future<Map<String, dynamic>?> validateUser(
      String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      _currentUser = result.first;
      return _currentUser;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getTasksByDate(String date) async {
    final db = await database;
    return await db.query(
      'tasks',
      where: 'start_date = ?',
      whereArgs: [date],
    );
  }

  Future<void> updateTaskStatus(int taskId, bool isCompleted) async {
    final db = await database;
    await db.update(
      'tasks',
      {'status': isCompleted ? 1 : 0},
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
  }

  Future<Map<String, dynamic>> getTaskById(int taskId) async {
    final db = await instance.database;
    final result = await db.query(
      'tasks',
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
    return result.isNotEmpty ? result.first : {};
  }

// Função para excluir uma tarefa
  Future<void> deleteTask(int taskId) async {
    final db = await instance.database;
    await db.delete(
      'tasks',
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
  }

  Future<bool> isLoggedIn() async {
    return _currentUser != null;
  }

  Map<String, dynamic> getCurrentUser() {
    return _currentUser!;
  }

  Future<void> updateUserProfilePicture(
      int userId, String profilePicturePath) async {
    final db = await database;
    await db.update(
      'users',
      {'profile_picture': profilePicturePath},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<String?> getUserProfilePicture(int userId) async {
    final db = await database;
    final result = await db.query(
      'users',
      columns: ['profile_picture'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty
        ? result.first['profile_picture'] as String?
        : null;
  }

  Future<Map<String, dynamic>> fetchSuggestedActivity() async {
    final response =
        await http.get(Uri.parse('https://bored.api.lewagon.com/api/activity/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load activity');
    }
  }
}
