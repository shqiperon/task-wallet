import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_wallet/models/task.dart';
import 'package:task_wallet/providers/tasks_provider.dart';
import 'package:task_wallet/screens/task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final formatter = DateFormat.yMd();

class NewTask extends ConsumerStatefulWidget {
  const NewTask({
    super.key,
    required this.setFilter,
  });

  final void Function(TaskFilter filter) setFilter;

  @override
  ConsumerState<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends ConsumerState<NewTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
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

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _presentTimePicker() async {
    final now = DateTime.now();
    final initialTime = _selectedTime ?? TimeOfDay.fromDateTime(now);

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
              titleMedium: TextStyle(fontSize: 20),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitNewTask() {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Fields cannot be empty.'),
            content: const Text(
                'Please make sure to fill all the fields including date.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    ref.read(tasksProvider.notifier).addTask(
        _titleController.text,
        _descriptionController.text,
        _selectedDate!.toIso8601String().substring(0, 10),
        _selectedTime!);

    scheduleTaskNotification(Task(
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDate!.toIso8601String().substring(0, 10),
      time: _selectedTime!,
    ));

    Navigator.pop(context);
    widget.setFilter(TaskFilter.all);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        right: 15,
        left: 15,
      ),
      child: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: _titleController,
            decoration: const InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                labelText: 'Task title'),
            maxLength: 50,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: 'Description',
                  ),
                  maxLength: 50,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _selectedDate == null
                        ? const Text(
                            'No date chosen',
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(
                            formatter.format(_selectedDate!),
                            style: const TextStyle(color: Colors.white),
                          ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              _selectedTime == null
                  ? const Text(
                      'Select time',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      '${_selectedTime!.hour}:${_selectedTime!.minute}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
              IconButton(
                  onPressed: _presentTimePicker,
                  icon: const Icon(
                    Icons.access_time_filled_outlined,
                    color: Colors.white,
                  ))
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                onPressed: _submitNewTask,
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: const Text('Add task'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
