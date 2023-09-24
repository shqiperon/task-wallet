import 'package:task_wallet/models/category.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum ExpenseCategory {
  food,
  clothes,
  equipment,
  tech,
  other,
}

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.year,
    required this.month,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final double amount;
  final Category category;
  final String year;
  final String month;
}
