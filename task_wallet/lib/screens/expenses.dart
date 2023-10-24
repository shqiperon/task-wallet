import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/expense.dart';
import 'package:task_wallet/providers/expense_provider.dart';
import 'package:task_wallet/widgets/circular_chart/circular_chart.dart';
import 'package:task_wallet/widgets/expenses/expenses_list.dart';
import 'package:task_wallet/widgets/expenses/new_expense.dart';
import 'package:task_wallet/widgets/filter_row.dart';

enum ExpenseFilter {
  all,
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key, required this.year});

  final String year;

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  late Future<void> _expensesFuture;
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();

  ExpenseFilter _currentFilter = ExpenseFilter.all;
  List<Expense> _filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    _expensesFuture =
        ref.read(expenseProvider.notifier).loadExpenses(widget.year);
    _expensesFuture.then((_) {
      _filterExpenses();
    });
  }

  void _filterExpenses() {
    setState(() {
      if (_currentFilter == ExpenseFilter.all) {
        _filteredExpenses = ref.watch(expenseProvider);
      } else {
        _filteredExpenses = ref.watch(expenseProvider).where((expense) {
          final month =
              expense.month.toLowerCase(); // Ensure month is in lowercase
          final filterMonth =
              _currentFilter.toString().split('.').last.toLowerCase();
          return month == filterMonth;
        }).toList();
      }
    });
  }

  void setFilter(ExpenseFilter filter) {
    setState(() {
      _currentFilter = filter;
      _filterExpenses();
    });
    _updateChart();
  }

  Future<void> _handleRefresh() async {
    await ref.read(expenseProvider.notifier).loadExpenses(widget.year);
    _updateChart();
  }

  void _updateChart() {
    if (_currentFilter == ExpenseFilter.all) {
      final expenses = ref.read(expenseProvider);
      setState(() {
        _filteredExpenses = expenses;
      });
    } else {
      final expenses = ref.read(expenseProvider);
      setState(() {
        _filteredExpenses = expenses.where((expense) {
          final month = expense.month.toLowerCase();
          final filterMonth =
              _currentFilter.toString().split('.').last.toLowerCase();
          return month == filterMonth;
        }).toList();
      });
    }
  }

  void addExpense() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewExpense(
            year: widget.year,
            onSetFilter: setFilter,
            onExpenseAdded: _handleRefresh),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 70, 69, 69),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        title: Text(
          'Expenses of ${widget.year}',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: addExpense,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FilterMonthRow(
                  selectedFilter: _currentFilter, onFilterChanged: setFilter),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Consumer(builder: (context, watch, child) {
                  return CircularChart(expenses: _filteredExpenses);
                }),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder(
                future: _expensesFuture,
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : ExpensesList(
                            expenses: _filteredExpenses,
                            onHandleRefresh: _handleRefresh),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
