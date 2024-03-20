import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/expense.dart';
import 'package:task_wallet/providers/chart_provider.dart';
import 'package:task_wallet/widgets/circular_chart/chart_legend.dart';

class CircularChart extends ConsumerWidget {
  const CircularChart({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, double> categoryAmounts = {};
    final calculateAmountForCategory = ref
        .read(circularChartStateProvider.notifier)
        .calculateAmountForCategory(expenses, categoryAmounts);
    final getColorForCategory =
        ref.read(circularChartStateProvider.notifier).getColorForCategory;
    final calculateTotal = ref
        .read(circularChartStateProvider.notifier)
        .calculateTotalAmount(expenses);
    final calculatePercentage = ref
        .read(circularChartStateProvider.notifier)
        .calculatePercentage(expenses);

    return Stack(
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 50,
            sections: calculateAmountForCategory.entries.map((entry) {
              return PieChartSectionData(
                title: '',
                value: entry.value,
                color: getColorForCategory(entry.key),
                radius: 42,
              );
            }).toList(),
          ),
        ),
        Positioned(
          left: 8,
          bottom: 5,
          child: ChartLegend(
            categoryAmounts: calculateAmountForCategory,
            getColorForCategory: getColorForCategory,
            categoryPercentages: calculatePercentage,
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
              'Total: \$${calculateTotal.toStringAsFixed(2)}',
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
