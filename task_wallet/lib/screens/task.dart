import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/models/task.dart';
import 'package:task_wallet/providers/tasks_provider.dart';
import 'package:task_wallet/widgets/tasks/new_task.dart';
import 'package:task_wallet/widgets/tasks/task_list.dart';

enum TaskFilter { all, today }

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  late Future<void> _tasksFuture;
  TaskFilter _currentFilter = TaskFilter.all;
  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _tasksFuture = ref.read(tasksProvider.notifier).loadTasks();
    _tasksFuture.then((_) {
      _filterTasks();
    });
  }

  void _openAddTasksOverlay() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      context: context,
      builder: (context) => NewTask(setFilter: setFilter),
    );
  }

  void _filterTasks() {
    final now = DateTime.now();
    setState(() {
      if (_currentFilter == TaskFilter.all) {
        _filteredTasks = ref.watch(tasksProvider);
      } else {
        _filteredTasks = ref.watch(tasksProvider).where((task) {
          return DateTime.parse(task.date).year == now.year &&
              DateTime.parse(task.date).month == now.month &&
              DateTime.parse(task.date).day == now.day;
        }).toList();
      }
    });
  }

  void setFilter(TaskFilter filter) {
    setState(() {
      _currentFilter = filter;
      _filterTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 70, 69, 69),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        title: Text(
          'Tasks',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _openAddTasksOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _currentFilter == TaskFilter.today
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Today',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'All',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                        ),
                      ),
                const Spacer(),
                const Text(
                  'Filter',
                  style: TextStyle(color: Colors.white),
                ),
                PopupMenuButton<TaskFilter>(
                  onSelected: (filter) {
                    setState(() {
                      _currentFilter = filter;
                      _filterTasks();
                    });
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<TaskFilter>(
                      value: TaskFilter.all,
                      child: Text('All'),
                    ),
                    const PopupMenuItem<TaskFilter>(
                      value: TaskFilter.today,
                      child: Text('Today'),
                    ),
                  ],
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _tasksFuture,
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : TaskList(tasks: _filteredTasks),
            ),
          ),
        ],
      ),
    );
  }
}
