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
      // body: ListView.separated(
      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //   itemCount: task.length,
      //   separatorBuilder: (BuildContext context, int index) {
      //     return const Divider(color: Colors.grey);
      //   },
      //   itemBuilder: (context, index) {
      //     return TodoListItem(index: index, task: task[index]);
      //   },
      // ),
      body: ReorderableListView.builder(
        itemCount: task.length,
        header: const AddTaskListTile(),
        footer: const AddTaskListTile(),
        itemBuilder: (context, index) {
          return Dismissible(
            // スワイプ禁止
            direction: DismissDirection.none,
            key: Key(task[index].title),
            child: TodoListItem(
              index: index,
              task: task[index],
            ),
          );
        },
        // ドラッグ&ドロップ時のメソッド
        onReorder: (oldIndex, newIndex) {
          debugPrint("onReorder");
          // setState(() {
          //   if (newIndex > oldIndex) {
          //     newIndex -= 1;
          //   }
          //   final item = _items.removeAt(oldIndex);
          //   _items.insert(newIndex, item);
          // });
        },
      ),
    );
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        child: ListTile(
          key: Key(task.title),
          title: Text(task.title),
          trailing: task.isCompleted
              ? Icon(Icons.check, color: Theme.of(context).primaryColor)
              : null,
        ),
      ),
    );
  }
}

class AddTaskListTile extends StatelessWidget {
  const AddTaskListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("AddTask");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: const ListTile(
          title: Text("タスクを追加"),
          leading: Icon(Icons.add),
        ),
      ),
    );
  }
}
