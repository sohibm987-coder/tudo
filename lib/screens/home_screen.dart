import 'package:flutter/material.dart';

import '../services/hive_service.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({
    super.key,
    required this.name,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Task {
  String title;
  bool isDone;

  Task({
    required this.title,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];

  @override
  void initState() {
    super.initState();

    loadTasks();
  }

  Future<void> loadTasks() async {
    final savedTasks = HiveService.getData('tasks');

    if (savedTasks == null) {
      return;
    }

    final List<dynamic> decodedTasks = savedTasks;

    setState(() {
      tasks.clear();

      for (final task in decodedTasks) {
        tasks.add(
          Task.fromMap(
            Map<String, dynamic>.from(task),
          ),
        );
      }
    });
  }

  Future<void> saveTasks() async {
    final List<Map<String, dynamic>> tasksMap = tasks
        .map(
          (task) => task.toMap(),
        )
        .toList();

    await HiveService.saveData(
      'tasks',
      tasksMap,
    );
  }

  Future<void> openAddTask() async {
    final newTask = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );

    if (newTask != null && newTask.trim().isNotEmpty) {
      setState(() {
        tasks.add(
          Task(
            title: newTask.trim(),
          ),
        );
      });

      await saveTasks();
    }
  }

  Future<void> toggleTask(int index) async {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });

    await saveTasks();
  }

  int get doneCount {
    return tasks.where((task) => task.isDone).length;
  }

  int get todoCount {
    return tasks.where((task) => !task.isDone).length;
  }

  // باقي build والواجهات تبقى كما هي عندك
}