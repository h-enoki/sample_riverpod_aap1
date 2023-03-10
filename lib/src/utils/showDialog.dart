import 'package:flutter/material.dart';
import 'package:sample_riverpod_aap1/src/components/edit_task_dialog.dart';

Future<String?> showAddTaskDialog(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return EditTaskDialog.addTask();
    },
  );
}

Future<String?> showAddFirstTaskDialog(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return EditTaskDialog.addFirstTask();
    },
  );
}

Future<String?> showEditTaskDialog(
  BuildContext context,
  int index,
  String title,
) async {
  return await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return EditTaskDialog.editTask(index, title);
    },
  );
}
