import 'package:flutter/material.dart';
import 'package:task_wallet/models/category.dart';
import 'package:task_wallet/models/expense.dart';

const categories = {
  ExpenseCategory.food: Category(title: 'Food', icon: Icons.restaurant),
  ExpenseCategory.clothes: Category(title: 'Clothes', icon: Icons.shopping_bag),
  ExpenseCategory.equipment:
      Category(title: 'Equipment', icon: Icons.home_filled),
  ExpenseCategory.tech: Category(title: 'Tech', icon: Icons.computer_rounded),
  ExpenseCategory.other: Category(title: 'Other', icon: Icons.money_sharp),
};
