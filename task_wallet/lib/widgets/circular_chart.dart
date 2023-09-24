import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:task_wallet/models/expense.dart';

class CircularChart extends StatelessWidget {
  const CircularChart({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryAmounts = {};

    double calculateTotalAmount(List<Expense> expenses) {
      double totalAmount = 0.0;
      for (var expense in expenses) {
        totalAmount += expense.amount;
      }
      return totalAmount;
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

    double totalAmount = calculateTotalAmount(expenses);
    final categoryPercentages = calculatePercentage(expenses);

    for (var expense in expenses) {
      final category = expense.category.title;
      final amount = expense.amount;

      if (categoryAmounts.containsKey(category)) {
        categoryAmounts[category] = categoryAmounts[category]! + amount;
      } else {
        categoryAmounts[category] = amount;
      }
    }

    Color getColorForCategory(String categoryName) {
      final Map<String, Color> categoryColors = {
        'Clothes': Colors.blue,
        'Food': Colors.green,
        'Tech': Colors.tealAccent,
        'Equipment': Colors.orange,
        'Other': Colors.purple,
      };

      // Check if the category name exists in the map, if not, use a default color
      final color = categoryColors[categoryName] ?? Colors.grey;

      return color;
    }

    return Stack(
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 50,
            sections: categoryAmounts.entries.map((entry) {
              return PieChartSectionData(
                title: '', // Category name
                value: entry.value, // Amount spent
                color: getColorForCategory(entry.key),
                radius: 45,
              );
            }).toList(),
          ),
        ),
        Positioned(
          bottom: 5,
          left: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryAmounts.entries
                .where((entry) =>
                    categoryAmounts.values.toList().indexOf(entry.value) < 3)
                .map((entry) {
              final category = entry.key;
              final color = getColorForCategory(category);
              final percentage = categoryPercentages[category]!;
              return Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 80,
                      child: Text(
                        category,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryAmounts.entries
                .where((entry) =>
                    categoryAmounts.values.toList().indexOf(entry.value) >= 3)
                .map((entry) {
              final category = entry.key;
              final color = getColorForCategory(category);
              final percentage = categoryPercentages[category]!;
              return Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 80,
                      child: Text(
                        category,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.white)),
            child: Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}', // Format the total amount as needed
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
