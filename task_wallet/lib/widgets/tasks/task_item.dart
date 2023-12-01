import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_wallet/models/task.dart';
import 'package:task_wallet/widgets/filter_row.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {super.key});

  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late Timer _timer;
  bool isTaskPassed = false;
  final currentDate = DateTime.now();
  late TimeOfDay time;
  late String date;
  late String year;
  late String month;
  late String day;
  late String formattedDate;
  late bool minutesUnderTen;
  late DateTime taskDate;
  late bool isToday;
  late bool isTomorrow;
  late bool isYesterday;

  @override
  void initState() {
    super.initState();
    _initializeTaskProperties();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initializeTaskProperties() {
    time = widget.task.time;
    date = widget.task.date;
    year = date.substring(2, 4);
    month = date.substring(5, 7);
    day = date.substring(8, 10);
    formattedDate = '$day.$month.$year';
    minutesUnderTen = time.minute < 10;

    taskDate = DateTime.parse(widget.task.date);
    isToday = currentDate.year == taskDate.year &&
        currentDate.month == taskDate.month &&
        currentDate.day == taskDate.day;
    isTomorrow = currentDate.year == taskDate.year &&
        currentDate.month == taskDate.month &&
        currentDate.day + 1 == taskDate.day;
    isYesterday = currentDate.year == taskDate.year &&
        currentDate.month == taskDate.month &&
        currentDate.day - 1 == taskDate.day;

    final taskDateWithTime = taskDate.add(Duration(
      hours: widget.task.time.hour,
      minutes: widget.task.time.minute,
    ));
    setState(() {
      isTaskPassed = currentDate.isAfter(taskDateWithTime);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final currentDate = DateTime.now();
      final taskDate = DateTime.parse(widget.task.date).add(Duration(
        hours: widget.task.time.hour,
        minutes: widget.task.time.minute,
      ));
      setState(() {
        isTaskPassed = currentDate.isAfter(taskDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          isTaskPassed ? const Color.fromARGB(255, 35, 35, 35) : Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              capitalize(widget.task.title),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                Text(
                  capitalize(widget.task.description),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: const Color.fromARGB(190, 255, 255, 255)),
                ),
              ],
            ),
            const SizedBox(height: 7),
            if (isTaskPassed)
              Row(
                children: [
                  if (isToday)
                    Text(
                      minutesUnderTen
                          ? 'Today, ${time.hour}:0${time.minute}'
                          : 'Today, ${time.hour}:${time.minute}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.red),
                    )
                  else if (isTomorrow)
                    Text(
                      minutesUnderTen
                          ? 'Tomorrow, ${time.hour}:0${time.minute}'
                          : 'Tomorrow, ${time.hour}:${time.minute}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.red),
                    )
                  else if (isYesterday)
                    Text(
                      minutesUnderTen
                          ? 'Yesterday, ${time.hour}:0${time.minute}'
                          : 'Yesterday, ${time.hour}:${time.minute}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.red),
                    )
                  else
                    Text(
                      minutesUnderTen
                          ? '$formattedDate, ${time.hour}:0${time.minute}'
                          : '$formattedDate, ${time.hour}:${time.minute}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.red),
                    )
                ],
              ),
            if (!isTaskPassed)
              Row(
                children: [
                  if (isToday)
                    Text(
                      minutesUnderTen
                          ? 'Today, ${time.hour}:0${time.minute}'
                          : 'Today, ${time.hour}:${time.minute}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: const Color.fromARGB(160, 255, 255, 255)),
                    )
                  else if (isTomorrow)
                    Text(
                      minutesUnderTen
                          ? 'Tomorrow, ${time.hour}:0${time.minute}'
                          : 'Tomorrow, ${time.hour}:${time.minute}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: const Color.fromARGB(160, 255, 255, 255)),
                    )
                  else if (isYesterday)
                    Text(
                      minutesUnderTen
                          ? 'Yesterday, ${time.hour}:0${time.minute}'
                          : 'Yesterday, ${time.hour}:${time.minute}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: const Color.fromARGB(160, 255, 255, 255)),
                    )
                  else
                    Text(
                      minutesUnderTen
                          ? '$formattedDate, ${time.hour}:0${time.minute}'
                          : '$formattedDate, ${time.hour}:${time.minute}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: const Color.fromARGB(160, 255, 255, 255)),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
