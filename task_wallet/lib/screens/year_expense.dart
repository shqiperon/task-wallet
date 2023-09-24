import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/providers/expense_provider.dart';
import 'package:task_wallet/widgets/years/new_year.dart';
import 'package:task_wallet/widgets/years/year_list.dart';

class YearExpenseScreen extends ConsumerStatefulWidget {
  const YearExpenseScreen({super.key});

  @override
  ConsumerState<YearExpenseScreen> createState() => _YearExpenseScreenState();
}

class _YearExpenseScreenState extends ConsumerState<YearExpenseScreen> {
  late Future<void> _yearsFuture;

  @override
  void initState() {
    super.initState();
    _yearsFuture = ref.read(yearProvider.notifier).loadYears();
  }

  @override
  Widget build(BuildContext context) {
    final yearList = ref.watch(yearProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 70, 69, 69),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        foregroundColor: Colors.white,
        title: Text(
          'Expenses of year',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewYear(
                  years: yearList,
                ),
              ));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: _yearsFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : YearList(years: yearList),
        ),
      ),
    );
  }
}
