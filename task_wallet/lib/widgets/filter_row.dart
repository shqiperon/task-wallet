import 'package:flutter/material.dart';
import 'package:task_wallet/screens/expenses.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class FilterMonthRow extends StatefulWidget {
  const FilterMonthRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });
  final ExpenseFilter selectedFilter;
  final ValueChanged<ExpenseFilter> onFilterChanged;

  @override
  State createState() => _FilterMonthRowState();
}

class _FilterMonthRowState extends State<FilterMonthRow> {
  ExpenseFilter _selectedFilter = ExpenseFilter.all;
  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
  }

  @override
  void didUpdateWidget(covariant FilterMonthRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFilter != _selectedFilter) {
      setState(() {
        _selectedFilter = widget.selectedFilter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ExpenseFilter.values
            .where((filter) => filter != ExpenseFilter.all)
            .map((filter) {
          final isSelected = filter == _selectedFilter;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                if (!isSelected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  widget.onFilterChanged(filter);
                } else {
                  setState(() {
                    _selectedFilter = ExpenseFilter.all;
                  });
                  widget.onFilterChanged(ExpenseFilter.all);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: isSelected ? Colors.black : Colors.transparent,
                ),
                child: Text(
                  capitalize(filter.toString().split('.').last),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
