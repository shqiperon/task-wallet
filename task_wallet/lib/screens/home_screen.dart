import 'package:flutter/material.dart';
import 'package:task_wallet/screens/task.dart';
import 'package:task_wallet/screens/year_expense.dart';
import 'package:task_wallet/widgets/home_cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String taskImageUrl =
        'https://images.pexels.com/photos/212285/pexels-photo-212285.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
    const String expensesImageUrl =
        'https://images.pexels.com/photos/6328858/pexels-photo-6328858.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 70, 69, 69),
          title: Text(
            'TaskWallet',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeCards(
                    screenWidget: TaskScreen(),
                    imageUrl: taskImageUrl,
                    buttonLabel: 'Add your tasks'),
                SizedBox(height: 20),
                HomeCards(
                    screenWidget: YearExpenseScreen(),
                    imageUrl: expensesImageUrl,
                    buttonLabel: 'Track your expenses'),
              ],
            ),
          ),
        ));
  }
}
