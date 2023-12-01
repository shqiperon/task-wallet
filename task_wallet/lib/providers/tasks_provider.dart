import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/task.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'tasks.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, date TEXT, time Text)');
    },
    version: 1,
  );
  return db;
}

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(const []);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleTaskNotification(Task task) async {
    tz.initializeTimeZones();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final taskDate = DateTime.parse(task.date);
    final taskTime = TimeOfDay(
      hour: task.time.hour,
      minute: task.time.minute,
    );

    tz.initializeTimeZones();
    final location = tz.getLocation('Europe/Tirane');
    final notificationTime = tz.TZDateTime(
      location,
      taskDate.year,
      taskDate.month,
      taskDate.day,
      taskTime.hour,
      taskTime.minute,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Task Reminder',
      'Task: ${task.title}',
      notificationTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

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
        Task(title: title, description: description, date: date, time: time);
    state = [...state, newTask];

    final db = await _getDatabase();
    db.insert('tasks', {
      'id': newTask.id,
      'title': newTask.title,
      'description': newTask.description,
      'date': newTask.date,
      'time': '${newTask.time.hour}:${newTask.time.minute}',
    });
    scheduleTaskNotification(newTask);
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);
