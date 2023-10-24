import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/task.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'tasks.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, date TEXT, time Text)');
    },
    // onUpgrade: (db, oldVersion, newVersion) {
    //   // Handle schema updates here
    //   if (oldVersion == 1 && newVersion == 2) {
    //     db.execute('ALTER TABLE tasks ADD COLUMN time TEXT');
    //   }
    // },
    version: 1, //
  );
  return db;
}

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(const []);

  void removeTaskById(String id) async {
    state.removeWhere((task) => task.id == id);
    final db = await _getDatabase();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> loadTasks() async {
    final db = await _getDatabase();
    final data = await db.query('tasks');
    final tasks = data.map((row) {
      final timeParts = (row['time'] as String).split(':');
      final time = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );

      return Task(
          id: row['id'] as String,
          title: row['title'] as String,
          description: row['description'] as String,
          date: row['date'] as String,
          time: time);
    }).toList();
    state = tasks;
  }

  void addTask(
      String title, String description, String date, TimeOfDay time) async {
    final newTask =
        Task(title: title, description: description, date: date, time: time); //
    state = [...state, newTask];

    final db = await _getDatabase();
    db.insert('tasks', {
      'id': newTask.id,
      'title': newTask.title,
      'description': newTask.description,
      'date': newTask.date,
      'time': '${newTask.time.hour}:${newTask.time.minute}',
    });
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);
