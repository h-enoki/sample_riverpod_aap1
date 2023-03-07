import 'package:flutter/material.dart';
import 'package:sample_riverpod_aap1/src/models/task.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<Task> task = [
    Task("task1", false),
    Task("task2", false),
    Task("task3", false),
    Task("task4", false),
    Task("task5", true),
    Task("task6", true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ToDoリスト"),
          actions: [
            IconButton(
              icon: const Icon(Icons.create_rounded),
              onPressed: () => {},
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: task.length,
          itemBuilder: (context, index) {
            return TodoListItem(index: index, task: task[index]);
          },
        ));
  }
}

class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.index, required this.task});

  final int index;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("onTap：$index");
      },
      child: ListTile(
        title: Text(task.title),
        trailing: task.isCompleted
            ? Icon(Icons.check, color: Theme.of(context).primaryColor)
            : null,
      ),
    );
  }
}
