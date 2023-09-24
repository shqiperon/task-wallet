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
  // Year? _removedYear;
  // Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
  //   return await showDialog<bool>(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: const Text('Confirm Deletion'),
  //             content: const Text('Are you sure you want to delete this year?'),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(false); // User canceled deletion
  //                 },
  //                 child: const Text('Cancel'),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(true); // User confirmed deletion
  //                 },
  //                 child: const Text('Delete'),
  //               ),
  //             ],
  //           );
  //         },
  //       ) ??
  //       false;
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.years.isEmpty) {
      return Center(
        child: Text(
          'No years added yet.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
        itemCount: widget.years.length,
        itemBuilder: (context, index) {
          final year = widget.years[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExpensesScreen(year: year.year),
                ),
              );
            },
            child: Dismissible(
              key: ValueKey(widget.years[index]),
              onDismissed: (direction) async {
                final yearToRemove = widget.years[index];
                ref.read(yearProvider.notifier).removeYear(yearToRemove.id);
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
