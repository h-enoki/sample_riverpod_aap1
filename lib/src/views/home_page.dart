import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<String> task = [
    "task1",
    "task2",
    "task3",
    "task4",
    "task5",
    "task6"
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
            return TodoListItem(title: task[index]);
          },
        ));
  }
}

class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
    );
  }
}
