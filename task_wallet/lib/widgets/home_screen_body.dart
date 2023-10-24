import 'package:flutter/material.dart';
import 'package:task_wallet/widgets/card/home_card.dart';
import 'package:task_wallet/widgets/card/home_card_state.dart';

import '../../screens/task.dart';
import '../../screens/year_expense.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final List<BaseWidgetState> widgetStates = [
    const HomeCardState(
        screen: TaskScreen(),
        imageUrl:
            'https://images.pexels.com/photos/212285/pexels-photo-212285.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        buttonLabel: "Add your tasks"),
    const SpaceWidgetState(height: 16),
    const HomeCardState(
        screen: YearExpenseScreen(),
        imageUrl:
            'https://images.pexels.com/photos/6328858/pexels-photo-6328858.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        buttonLabel: 'Track your expenses'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 70, 69, 69),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        foregroundColor: Colors.white,
        title: Text(
          'TaskWallet',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgetStates.map((element) {
                if (element is HomeCardState) {
                  return HomeCard(state: element);
                } else if (element is SpaceWidgetState) {
                  return SizedBox(height: element.height);
                }
                return Container();
              }).toList()),
        ),
      ),
    );
  }
}
