import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_riverpod_aap1/src/models/task.dart';

import 'package:sample_riverpod_aap1/src/views/todo_list_page/todo_list_page.dart';

enum AddEditMode {
  add,
  addFirst,
  edit,
}

class EditTaskDialog extends ConsumerWidget {
  const EditTaskDialog({
    super.key,
    required this.addEditMode,
    this.index,
    this.title,
  });

  final AddEditMode addEditMode;
  final int? index;
  final String? title;

  factory EditTaskDialog.addTask() {
    return const EditTaskDialog(addEditMode: AddEditMode.add);
  }

  factory EditTaskDialog.addFirstTask() {
    return const EditTaskDialog(addEditMode: AddEditMode.addFirst);
  }

  factory EditTaskDialog.editTask(int index, String title) {
    return EditTaskDialog(
        addEditMode: AddEditMode.edit, index: index, title: title);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextFieldのコントローラー
    final TextEditingController textEditingController = TextEditingController();
    if (addEditMode == AddEditMode.edit) {
      textEditingController.text = title!;
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: (() {
          switch (addEditMode) {
            case AddEditMode.add:
              return const Text("タスクを追加");
            case AddEditMode.addFirst:
              return const Text("タスクを追加");
            case AddEditMode.edit:
              return const Text("タスクを編集");
          }
        })(),
        content: TextField(
          keyboardType: TextInputType.text,
          controller: textEditingController,
          decoration: const InputDecoration(hintText: "タスクを入力"),
          enabled: true,
          maxLength: 20,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
        actions: <Widget>[
          // ボタン領域
          TextButton(
            child: const Text("キャンセル"),
            onPressed: () => Navigator.pop(context, "キャンセル"),
          ),
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              String textValue = textEditingController.text;
              switch (addEditMode) {
                case AddEditMode.add:
                  ref
                      .read(taskNotifierProvider.notifier)
                      .addTask(Task(textValue, false));
                  break;
                case AddEditMode.addFirst:
                  ref
                      .read(taskNotifierProvider.notifier)
                      .addFirstTask(Task(textValue, false));
                  break;
                case AddEditMode.edit:
                  ref
                      .read(taskNotifierProvider.notifier)
                      .updateTask(index!, textValue);
                  break;
              }
              Navigator.pop(context, "OK");
            },
          ),
        ],
      ),
    );
  }
}
