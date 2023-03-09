import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_riverpod_aap1/src/models/task.dart';

import 'package:sample_riverpod_aap1/src/views/home_page.dart';

enum AddEditMode {
  add,
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
            switch (addEditMode) {
              case AddEditMode.add:
                ref
                    .read(taskNotifierProvider.notifier)
                    .addTask(Task(textValue, false));
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
    );
  }
}
