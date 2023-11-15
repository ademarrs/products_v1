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

class ImageSelectDialog extends StatelessWidget {
  final Function onCameraSelect;
  final Function onGalerySelect;
  final String dialogTitle;
  final String dialogContent;

  const ImageSelectDialog(
      {super.key,
      required this.onCameraSelect,
      required this.onGalerySelect,
      required this.dialogTitle,
      required this.dialogContent});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(dialogTitle),
      content: Text(dialogContent),
      actions: <Widget>[
        TextButton.icon(
          icon: const Icon(Icons.camera),
          onPressed: () {
            onCameraSelect();
            Navigator.of(context).pop(); // Close the dialog
          },
          label: const Text('Usar a camera para fotografar'),
        ),
        TextButton.icon(
          icon: const Icon(Icons.browse_gallery),
          onPressed: () {
            onGalerySelect();
            Navigator.of(context).pop(); // Close the dialog
          },
          label: const Text('Selecionar imagem da Galeria'),
        ),
        TextButton.icon(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          label: const Text('Fechar'),
        ),
      ],
    );
  }
}
