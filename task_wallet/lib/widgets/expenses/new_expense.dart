import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/data/categories.dart';
import 'package:task_wallet/models/expense.dart';
import 'package:task_wallet/providers/expense_provider.dart';
import 'package:task_wallet/screens/expenses.dart';

class NewExpense extends ConsumerStatefulWidget {
  const NewExpense(
      {super.key,
      required this.year,
      required this.onSetFilter,
      required this.onExpenseAdded});

  final String year;
  final void Function(ExpenseFilter filter) onSetFilter;
  final void Function() onExpenseAdded;

  @override
  ConsumerState<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends ConsumerState<NewExpense> {
  final formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  double _enteredAmount = 0;
  var _selectedCategory = categories[ExpenseCategory.other];

  static const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String _selectedMonth = monthNames[DateTime.now().month - 1];

  void _saveExpense() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      ref.read(expenseProvider.notifier).addExpense(
            _enteredTitle,
            _enteredAmount,
            _selectedCategory!,
            widget.year,
            _selectedMonth,
          );
      widget.onExpenseAdded();
      Navigator.pop(context);
    }
    widget.onSetFilter(ExpenseFilter.all);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 30,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length >= 30) {
                    return 'Must be between 1 and 30 characters.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  setState(() {
                    _enteredTitle = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(
                          color: Colors.white,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp("[0-9]"),
                        ),
                      ],
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value)! <= 0) {
                          return 'Amount must be more than 0';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        setState(() {
                          _enteredAmount = double.parse(newValue!);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      dropdownColor: const Color.fromARGB(255, 47, 47, 47),
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Icon(category.value.icon, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  category.value.title,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      dropdownColor: const Color.fromARGB(255, 47, 47, 47),
                      value: _selectedMonth,
                      items: monthNames.map((month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Text(
                            month,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveExpense,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: const Text('Add expense'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
