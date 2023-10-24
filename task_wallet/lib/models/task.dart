import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Task {
  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String description;
  final String date;
  final TimeOfDay time;
}
