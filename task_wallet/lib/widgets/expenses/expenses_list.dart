import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/expense.dart';
import 'package:task_wallet/providers/expense_provider.dart';
import 'package:task_wallet/widgets/expenses/expense_item.dart';

class ExpensesList extends ConsumerStatefulWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onHandleRefresh,
  });

  final List<Expense> expenses;
  final void Function() onHandleRefresh;

  @override
  ConsumerState<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends ConsumerState<ExpensesList> {
  bool _undoPressed = false;
  Timer? _timer;
  @override
  Widget build(BuildContext context) {
    if (widget.expenses.isEmpty) {
      return Center(
        child: Text(
          'No expenses added yet.',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white),
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.expenses.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(widget.expenses[index]),
        onDismissed: (direction) async {
          final expenseToRemove = widget.expenses[index];
          final snackBar = SnackBar(
            duration: const Duration(milliseconds: 2000),
            content: const Text('Expense deleted.'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                _undoPressed = true;
                setState(() {
                  widget.expenses.insert(index, expenseToRemove);
                });
                widget.onHandleRefresh();
              },
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            widget.expenses.removeAt(index);
          });

          _timer?.cancel();
          _timer = Timer(const Duration(milliseconds: 3000), () {
            if (!_undoPressed) {
              ref
                  .read(expenseProvider.notifier)
                  .removeExpense(expenseToRemove.id);
            }
            widget.onHandleRefresh();
            _undoPressed = false;
          });
        },
        direction: DismissDirection.endToStart,
        background: Container(
          padding: const EdgeInsets.only(right: 10),
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(color: Colors.red),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: ExpenseItem(
          widget.expenses[index],
        ),
      ),
    );
  }
}

// AnimatedContainer(
//           duration: const Duration(milliseconds: 1000),
//           curve: Curves.easeInOut,
//           transform: _undoPressed
//               ? Matrix4.translationValues(-100.0, 0.0, 0.0)
//               : Matrix4.translationValues(0.0, 0.0, 0.0),
//           child: ExpenseItem(
//             widget.expenses[index],
//           ),
//         ),