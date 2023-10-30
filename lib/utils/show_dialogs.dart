import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onDeleteConfirmed;
  final String dialogTitle;
  final String dialogContent;

  const DeleteConfirmationDialog({
    super.key,
    required this.onDeleteConfirmed,
    required this.dialogTitle,
    required this.dialogContent,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(dialogTitle),
      content: Text(dialogContent),
      actions: <Widget>[
        TextButton.icon(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          label: const Text('Não'),
        ),
        TextButton.icon(
          icon: const Icon(Icons.delete_forever),
          onPressed: () {
            onDeleteConfirmed();
            Navigator.of(context).pop(); // Close the dialog
          },
          label: const Text('Sim'),
        ),
      ],
    );
  }
}
