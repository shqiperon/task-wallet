import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/year.dart';
import 'package:task_wallet/providers/expense_provider.dart';
import 'package:task_wallet/screens/expenses.dart';
import 'package:task_wallet/widgets/years/year_item.dart';

class YearList extends ConsumerStatefulWidget {
  const YearList({super.key, required this.years});

  final List<Year> years;

  @override
  ConsumerState<YearList> createState() => _YearListState();
}

class _YearListState extends ConsumerState<YearList> {
  void _showDeleteConfirmationDialog(BuildContext context, int index) async {
    final removedYear = widget.years[index];

    setState(() {
      widget.years.removeAt(index);
    });

    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
            'Do you want to delete expenses of ${removedYear.year}?',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (isConfirmed == true) {
      ref.read(yearProvider.notifier).removeYear(removedYear.id);
      ref
          .read(expenseProvider.notifier)
          .removeExpensesFromYear(removedYear.year);
    } else {
      setState(() {
        widget.years.insert(index, removedYear);
      });
    }
  }

  Future<void> _navigateToExpenses(BuildContext context, Year year) async {
    final formKey = GlobalKey<FormState>();
    final bool? isPasswordCorrect = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter password to unlock expenses',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty || value != year.password) {
                  return 'Password incorret';
                }
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                labelText: 'Password',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(true);
                }
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (isPasswordCorrect == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExpensesScreen(year: year.year),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.years.isEmpty) {
      return Center(
        child: Text(
          'No years added yet.',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
        itemCount: widget.years.length,
        itemBuilder: (context, index) {
          final year = widget.years[index];
          return GestureDetector(
            onTap: () {
              if (year.password == null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExpensesScreen(year: year.year),
                  ),
                );
              } else {
                _navigateToExpenses(context, year);
              }
            },
            child: Dismissible(
              key: ValueKey(widget.years[index]),
              onDismissed: (direction) async {
                _showDeleteConfirmationDialog(context, index);
              },
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                decoration: const BoxDecoration(color: Colors.red),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: YearItem(year: year),
            ),
          );
        });
  }
}
