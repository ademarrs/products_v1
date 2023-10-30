import 'package:flutter/material.dart';
import 'package:standard_dialogs/dialogs/result_dialog.dart';

Future<bool> validateProductFields(
    BuildContext context, String name, double? balance) async {
  if (name.isEmpty) {
    await showErrorDialog(context,
        title: const Text('Preencha o nome do produto.'));
    return false;
  }
  if (name.length > 150) {
    await showErrorDialog(context,
        title: const Text('O nome do produto só pode ter até 150 caracteres.'));
    return false;
  }
  if (balance == null) {
    await showErrorDialog(context,
        title: const Text('Preencha o saldo do produto.'));
    return false;
  }
  if (balance < 0) {
    await showErrorDialog(context,
        title: const Text('O saldo do produto não pode ser negativo.'));
    return false;
  }
  return true;
}
