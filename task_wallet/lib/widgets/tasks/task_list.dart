import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/task.dart';
import 'package:task_wallet/providers/tasks_provider.dart';
import 'package:task_wallet/widgets/tasks/task_item.dart';

class TaskList extends ConsumerWidget {
  const TaskList({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks added yet.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(tasks[index]),
        onDismissed: (direction) {
          final taskToRemove = tasks[index];
          ref.read(tasksProvider.notifier).removeTaskById(taskToRemove.id);
        },
        direction: DismissDirection.endToStart,
        background: Container(
          padding: const EdgeInsets.only(right: 10),
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(color: Colors.red),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: TaskItem(
          tasks[index],
        ),
      ),
    );
  }
}
