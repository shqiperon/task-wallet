import 'package:flutter/material.dart';

class ChartLegend extends StatelessWidget {
  const ChartLegend({
    super.key,
    required this.categoryAmounts,
    required this.getColorForCategory,
    required this.categoryPercentages,
  });

  final Map<String, double> categoryAmounts;
  final Color Function(String) getColorForCategory;
  final Map<String, double> categoryPercentages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categoryAmounts.entries.map((entry) {
        final category = entry.key;
        final color = getColorForCategory(category);
        final percentage = categoryPercentages[category]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
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
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
