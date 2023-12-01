import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/category.dart';
import 'package:task_wallet/models/expense.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:task_wallet/models/year.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'expenses.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE expenses(id TEXT PRIMARY KEY, title TEXT, amount DOUBLE, category TEXT, year TEXT, month TEXT)');
    },
    version: 1,
  );
  return db;
}

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  ExpenseNotifier() : super(const []);

  void removeExpense(String id) async {
    state.removeWhere((expense) => expense.id == id);
    final db = await _getDatabase();
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  void removeExpensesFromYear(String yearValue) async {
    state.removeWhere((expense) => expense.year == yearValue);
    final db = await _getDatabase();
    await db.delete('expenses', where: 'year = ?', whereArgs: [yearValue]);
  }

  double getTotalExpenses(String year) {
    double total = 0.0;
    for (final expense in state) {
      if (expense.year == year) {
        total += expense.amount;
      }
    }
    return total;
  }

  Future<void> loadExpenses(String year) async {
    final db = await _getDatabase();
    final data =
        await db.query('expenses', where: 'year = ?', whereArgs: [year]);
    final expenses = data.map((row) {
      return Expense(
        id: row['id'] as String,
        title: row['title'] as String,
        amount: row['amount'] as double,
        category: Category(title: row['category'] as String),
        year: row['year'] as String,
        month: row['month'] as String,
      );
    }).toList();
    state = expenses;
  }

  void addExpense(String title, double amount, Category category, String year,
      String month) async {
    final newExpense = Expense(
      title: title,
      amount: amount,
      category: category,
      year: year,
      month: month,
    );

    final db = await _getDatabase();
    db.insert('expenses', {
      'id': newExpense.id,
      'title': newExpense.title,
      'amount': newExpense.amount,
      'category': newExpense.category.title,
      'year': newExpense.year,
      'month': newExpense.month.toLowerCase(),
    });

    state = [...state, newExpense];
  }
}

final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>(
  (ref) => ExpenseNotifier(),
);

final filteredExpensesProvider = Provider<List<Expense>>((ref) {
  return ref.watch(expenseProvider);
});

Future<Database> _getYearDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'years.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE years(id TEXT PRIMARY KEY, year TEXT, password TEXT)');
    },
    version: 1,
  );
  return db;
}

class YearNotifier extends StateNotifier<List<Year>> {
  YearNotifier() : super(const []);

  void updateYearPassword(String yearId, String? password) async {
    final yearToUpdate = state.firstWhere((year) => year.id == yearId);
    yearToUpdate.password = password;

    final db = await _getYearDatabase();
    await db.update(
      'years',
      {'password': password},
      where: 'id = ?',
      whereArgs: [yearId],
    );

    state = [...state];
  }

  void removeYear(String id) async {
    state.removeWhere((year) => year.id == id);
    final db = await _getYearDatabase();
    await db.delete('years', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> loadYears() async {
    final db = await _getYearDatabase();
    final data = await db.query('years');
    final years = data.map((row) {
      return Year(
        id: row['id'] as String,
        year: row['year'] as String,
        password: row['password'] as String?,
      );
    }).toList();
    state = years;
  }

  void addYear(String year, {String? password}) async {
    final newYear = Year(year: year);

    final db = await _getYearDatabase();
    db.insert('years', {
      'id': newYear.id,
      'year': newYear.year,
      'password': newYear.password,
    });

    state = [...state, newYear];
  }
}

final yearProvider =
    StateNotifierProvider<YearNotifier, List<Year>>((ref) => YearNotifier());
