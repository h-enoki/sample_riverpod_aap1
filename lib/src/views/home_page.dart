import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_riverpod_aap1/src/models/task.dart';

final isEditingProvider = StateProvider<bool>((ref) {
  return false;
});

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier()
      : super(
          [
            Task("task1", false),
            Task("task2", false),
            Task("task3", false),
            Task("task4", false),
            Task("task5", true),
            Task("task6", true),
          ],
        );

  void addTask(Task task) {
    debugPrint("addTask");
    state = [...state, task];
  }

  void removeTask(int index) {
    debugPrint("removeTask");
    state = List.from(state)..removeAt(index);
  }

  void updateIsCompleted(int index) {
    final List<Task> newState = [...state];
    newState[index] = Task(newState[index].title, !newState[index].isCompleted);
    state = newState;
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditingStateController = ref.read(isEditingProvider.notifier);
    final isEditing = ref.watch(isEditingProvider);

    final task = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDoリスト"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.create_rounded),
            onPressed: () => {
              isEditingStateController.state = !isEditing,
            },
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: task.length,
        header: isEditing ? const AddTaskListTile() : null,
        footer: isEditing ? const AddTaskListTile() : null,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(index.toString()),
            // スワイプ禁止
            direction: DismissDirection.none,
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

class TodoListItem extends ConsumerWidget {
  const TodoListItem({super.key, required this.index, required this.task});

  final int index;
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider);
    return InkWell(
      onTap: () {
        debugPrint("onTap：$index");
        // ref.read(taskNotifierProvider.notifier).updateTask(
        //       index,
        //       Task("task10", true),
        //     );
        ref.read(taskNotifierProvider.notifier).updateIsCompleted(index);
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
          title: Text(task.title),
          trailing: isEditing
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    ref.read(taskNotifierProvider.notifier).removeTask(index);
                  },
                )
              : task.isCompleted
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
        ),
      ),
    );
  }
}

class AddTaskListTile extends ConsumerWidget {
  const AddTaskListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(taskNotifierProvider.notifier).addTask(Task("task6", false));
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
