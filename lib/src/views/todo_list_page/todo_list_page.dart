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
      Task("task1", false),
      Task("task2", false),
      Task("task3", false),
      Task("task4", false),
      Task("task5", true),
      Task("task6", true),
    ],
  );
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier(List<Task> state) : super(state);

  void addTask(Task task) {
    state = [...state, task];
  }

  void updateTask(int index, String title) {
    state = [
      ...state.sublist(0, index),
      Task(title, state[index].isCompleted),
      ...state.sublist(index + 1),
    ];
  }

  void removeTask(int index) {
    state = List.from(state)..removeAt(index);
  }

  void updateIsCompleted(int index) {
    state = [
      ...state.sublist(0, index),
      Task(state[index].title, !state[index].isCompleted),
      ...state.sublist(index + 1),
    ];
  }

  void reorderTask(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);
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
            onPressed: () => {
              ref.read(isEditingProvider.notifier).state = !isEditing,
            },
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: task.length,
        header: isEditing ? const AddTaskListTile() : null,
        footer: isEditing ? const AddTaskListTile() : null,
        itemBuilder: (context, index) {
          // DismissibleWidgetのdirectionでスワイプを禁止
          return Dismissible(
            key: Key(index.toString()),
            direction: DismissDirection.none,
            child: TodoListItem(
              index: index,
              task: task[index],
            ),
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

Future<String?> showEditTaskDialog(
  BuildContext context,
  AddEditMode addEditMode, {
  int? index,
  String? title,
}) async {
  return await showDialog<String>(
    context: context,
    builder: (_) {
      switch (addEditMode) {
        case AddEditMode.add:
          return EditTaskDialog.addTask();
        case AddEditMode.edit:
          return EditTaskDialog.editTask(index!, title!);
      }
    },
  );
}
