import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_riverpod_aap1/src/models/task.dart';

import 'package:sample_riverpod_aap1/src/views/home_page.dart';

enum AddEditMode {
  add,
  edit,
}

class AddTaskDialog extends ConsumerWidget {
  const AddTaskDialog({
    super.key,
    required this.addEditMode,
    this.title,
  });

  final AddEditMode addEditMode;
  final String? title;

  factory AddTaskDialog.addTask() {
    return const AddTaskDialog(addEditMode: AddEditMode.add);
  }

  factory AddTaskDialog.editTask(String title) {
    return AddTaskDialog(addEditMode: AddEditMode.edit, title: title);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextFieldのコントローラー
    final TextEditingController textEditingController = TextEditingController();
    if (addEditMode == AddEditMode.edit) {
      textEditingController.text = title!;
    }

    return AlertDialog(
      title: Text(addEditMode.toString()),
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
            ref
                .read(taskNotifierProvider.notifier)
                .addTask(Task(textValue, false));
            Navigator.pop(context, "OK");
          },
        ),
      ],
    );
  }
}
