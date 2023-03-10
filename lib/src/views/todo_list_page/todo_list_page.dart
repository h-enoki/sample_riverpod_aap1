import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_riverpod_aap1/src/components/edit_task_dialog.dart';
import 'package:sample_riverpod_aap1/src/models/task.dart';
import 'package:sample_riverpod_aap1/src/views/todo_list_page/parts/todo_list_item.dart';

import 'parts/add_task_list_tile.dart';

final isEditingProvider = StateProvider<bool>((ref) {
  return false;
});

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(
    [
      const Task("task1", false),
      const Task("task2", false),
      const Task("task3", false),
      const Task("task4", false),
      const Task("task5", true),
      const Task("task6", true),
    ],
  );
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier(List<Task> state) : super(state);

  void addTask(Task task) {
    state = [...state, task];
  }

  void addFirstTask(Task task) {
    state = [task, ...state];
  }

  void updateTask(int index, String title) {
    state = [
      ...state.sublist(0, index),
      state[index].copyWith(title: title),
      ...state.sublist(index + 1),
    ];
  }

  void removeTask(int index) {
    state = List.from(state)..removeAt(index);
  }

  void updateIsCompleted(int index) {
    state = [
      ...state.sublist(0, index),
      state[index].copyWith(isCompleted: !state[index].isCompleted),
      ...state.sublist(index + 1),
    ];
  }

  void reorderTask(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final newState = List<Task>.from(state);
    newState.insert(newIndex, newState.removeAt(oldIndex));
    state = newState;
  }
}

class ToDoListPage extends ConsumerWidget {
  const ToDoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider);
    final task = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDoリスト"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.create_rounded),
            onPressed: () =>
                ref.read(isEditingProvider.notifier).state = !isEditing,
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: task.length,
        header: isEditing
            ? const AddTaskListTile(addEditMode: AddEditMode.addFirst)
            : null,
        footer: isEditing
            ? const AddTaskListTile(addEditMode: AddEditMode.add)
            : null,
        itemBuilder: (context, index) {
          return TodoListItem(
            key: Key(index.toString()),
            index: index,
            task: task[index],
          );
        },
        // ドラッグ&ドロップ時のメソッド
        onReorder: (oldIndex, newIndex) {
          ref
              .read(taskNotifierProvider.notifier)
              .reorderTask(oldIndex, newIndex);
        },
      ),
    );
  }
}
