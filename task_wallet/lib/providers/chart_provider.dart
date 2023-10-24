import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/expense.dart';

final circularChartStateProvider =
    StateNotifierProvider<CircularChartState, List<Expense>>((ref) {
  return CircularChartState();
});

class CircularChartState extends StateNotifier<List<Expense>> {
  CircularChartState() : super(const []);

  double calculateTotalAmount(List<Expense> expenses) {
    double totalAmount = 0.0;
    for (var expense in expenses) {
      totalAmount += expense.amount;
    }
    return totalAmount;
  }

  Map<String, double> calculateAmountForCategory(
      List<Expense> expenses, Map<String, double> categoryAmounts) {
    for (var expense in expenses) {
      final category = expense.category.title;
      final amount = expense.amount;

      if (categoryAmounts.containsKey(category)) {
        categoryAmounts[category] = categoryAmounts[category]! + amount;
      } else {
        categoryAmounts[category] = amount;
      }
    }
    return categoryAmounts;
  }

  Map<String, double> calculatePercentage(List<Expense> expenses) {
    Map<String, double> categoryAmounts = {};
    double totalAmountForCategory = calculateTotalAmount(expenses);

    for (var expense in expenses) {
      final category = expense.category.title;
      final amount = expense.amount;

      if (categoryAmounts.containsKey(category)) {
        categoryAmounts[category] = categoryAmounts[category]! +
            (amount / totalAmountForCategory) * 100.0;
      } else {
        categoryAmounts[category] = (amount / totalAmountForCategory) * 100.0;
      }
    }
    return categoryAmounts;
  }

  Color getColorForCategory(String categoryName) {
    final Map<String, Color> categoryColors = {
      'Clothes': const Color.fromARGB(255, 120, 159, 231),
      'Food': const Color.fromARGB(255, 74, 131, 239),
      'Tech': const Color.fromARGB(255, 35, 88, 186),
      'Equipment': const Color.fromARGB(255, 10, 63, 161),
      'Other': const Color.fromARGB(255, 5, 30, 77),
    };
    return categoryColors[categoryName] ?? Colors.grey;
  }
}
