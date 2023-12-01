import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/year.dart';
import 'package:task_wallet/providers/expense_provider.dart';

class YearItem extends ConsumerWidget {
  const YearItem({super.key, required this.year});

  final Year year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPassword = year.password != null ? true : false;

    void showPasswordDialog(BuildContext context) async {
      String? newPassword;
      final formKey = GlobalKey<FormState>();
      await showDialog(
        context: context,
        builder: (context) {
          if (!hasPassword) {
            return AlertDialog(
              title: Text('Set Password for ${year.year}'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    newPassword = value;
                  },
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
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
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    formKey.currentState!.validate();
                    if (newPassword != null) {
                      ref
                          .read(yearProvider.notifier)
                          .updateYearPassword(year.id, newPassword);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                  child: const Text('Save'),
                ),
              ],
            );
          } else {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 42, 41, 41),
              iconColor: Colors.white,
              shadowColor: Colors.white,
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
              title: const Text('Password already exist.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text('OK'),
                ),
              ],
            );
          }
        },
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expenses of ${year.year}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    hasPassword ? 'Locked' : 'Lock it now',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: hasPassword
                            ? Colors.white
                            : const Color.fromARGB(153, 255, 255, 255)),
                  ),
                  IconButton(
                    onPressed: () {
                      showPasswordDialog(context);
                    },
                    icon: Icon(
                      hasPassword ? Icons.lock : Icons.lock_open,
                      size: 35,
                      color: hasPassword
                          ? Colors.white
                          : const Color.fromARGB(131, 255, 255, 255),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
