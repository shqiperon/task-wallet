import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/year.dart';
import 'package:task_wallet/providers/expense_provider.dart';

class NewYear extends ConsumerStatefulWidget {
  const NewYear({super.key, required this.years});

  final List<Year> years;

  @override
  ConsumerState<NewYear> createState() => _NewYearState();
}

class _NewYearState extends ConsumerState<NewYear> {
  final formKey = GlobalKey<FormState>();
  var _enteredYear = '';

  void _saveYear() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (widget.years.any((year) => year.year == _enteredYear)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Year already exists.')),
        );
      } else {
        ref.read(yearProvider.notifier).addYear(_enteredYear);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Year'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 30,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp("[0-9]"),
                  ),
                ],
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Year',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length != 4 ||
                      int.tryParse(value)! > currentYear) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    } else if (int.tryParse(value)! > currentYear) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Year cannot be greater than the current year.'),
                        ),
                      );
                    }
                    return 'Invalid Value.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  setState(() {
                    _enteredYear = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 10,
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
                    onPressed: _saveYear,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: const Text('Add Year'),
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
