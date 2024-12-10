import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._constructor();
  Map<String, dynamic>? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DataBaseService._constructor();

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

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

    await _firestore.collection('tasks').add({
      'title': title,
      'description': description,
      'start_date': startTime,
      'end_date': endTime,
      'priority': priority,
      'alert': alert,
      'created_by': _auth.currentUser?.uid,
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

    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
      'username': username,
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

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      _currentUser = userDoc.data() as Map<String, dynamic>?;
      return _currentUser;
    } catch (e) {
      return null;
    }
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

    QuerySnapshot taskSnapshot = await _firestore
        .collection('tasks')
        .where('task_id', isEqualTo: taskId)
        .get();
    if (taskSnapshot.docs.isNotEmpty) {
      await _firestore
          .collection('tasks')
          .doc(taskSnapshot.docs.first.id)
          .update({'status': isCompleted ? 1 : 0});
    }
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

  Future<void> deleteTask(int taskId) async {
    final db = await instance.database;
    await db.delete(
      'tasks',
      where: 'task_id = ?',
      whereArgs: [taskId],
    );

    QuerySnapshot taskSnapshot = await _firestore
        .collection('tasks')
        .where('task_id', isEqualTo: taskId)
        .get();
    if (taskSnapshot.docs.isNotEmpty) {
      await _firestore
          .collection('tasks')
          .doc(taskSnapshot.docs.first.id)
          .delete();
    }
  }

  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  Map<String, dynamic> getCurrentUser() {
    return _currentUser!;
  }
}
