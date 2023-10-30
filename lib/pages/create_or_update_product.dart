import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:products/dao/product_dao.dart';
import 'package:products/model/product_model.dart';
import 'package:products/utils/error_dialog.dart';
import 'package:standard_dialogs/dialogs/result_dialog.dart';

// text fields' controllers
final TextEditingController _nameController = TextEditingController();
final TextEditingController _detailedNameController = TextEditingController();
final TextEditingController _balanceController = TextEditingController();

final ProductDao _productDao = ProductDao();
CollectionReference productss = dataBase.collection('products');

Future<void> createOrUpdateProduct(BuildContext context, String? emailUser,
    [DocumentSnapshot? documentSnapshot]) async {
  String action = 'create';
  bool active = true;

  if (documentSnapshot != null) {
    action = 'update';
    _nameController.text = documentSnapshot['name'];
    _detailedNameController.text = documentSnapshot['detailed_name'];
    _balanceController.text = documentSnapshot['balance'].toString();
    if (documentSnapshot['active'] != '') {
      active = documentSnapshot['active'];
    }
  }

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              // prevent the soft keyboard from covering text fields
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _detailedNameController,
                decoration:
                    const InputDecoration(labelText: 'Detalhamento do item'),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _balanceController,
                decoration: const InputDecoration(
                  labelText: 'Saldo',
                ),
              ),
              // nao deu certo o uso do switch, tem qu ver melhor como fazer
              // Switch(
              //   value: active,
              //   onChanged: (bool value) {
              //     setState(() {
              //       active = value;
              //     });
              //   },
              // ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(action == 'create' ? 'Incluir' : 'Atualizar'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple), //(Colors.red),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 20))),
                    onPressed: () {
                      try {
                        insertUpdateProduct(context, action, active, emailUser,
                            documentSnapshot);
                        // Hide the bottom sheet
                        if (action == 'update') {
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        ErrorDialog.showErrorDialog(
                            context, 'Erro  ${e.toString()}');
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple), //(Colors.red),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 20))),
                    onPressed: () {
                      clearFields();
                      Navigator.of(context).pop();
                    },
                    label: const Text('Fechar'),
                  ),
                ],
              )
            ],
          ),
        );
      });
}

clearFields() {
  _nameController.clear();
  _detailedNameController.clear();
  _balanceController.text = '';
}

Future<void> insertUpdateProduct(BuildContext context, String action,
    bool active, String? emailUser, DocumentSnapshot? documentSnapshot) async {
  //bool active = true;
  final String name = _nameController.text;
  final String detailedName = _detailedNameController.text;
  final double? balance = double.tryParse(_balanceController.text);
//    active = documentSnapshot['active'];
  // AuthService auth = Provider.of<AuthService>(context);
  // String username = 'ademar@datalan.inf.br';

  if (await validateProductFields(context, name, balance)) {
    try {
      if (action == 'create') {
        await _productDao.insertProduct(
            name, detailedName, balance!, active, emailUser);
      }

      if (action == 'update') {
        await _productDao.updateProduct(
            name, detailedName, balance!, active, emailUser, documentSnapshot);
      }
      if (action == 'create') {
        // so mostra mensagem na inclusao , na alteração não é necessário
        // ignore: use_build_context_synchronously
        await showSuccessDialog(context,
            title: const Text('Registro gravado com sucesso!'));
      }
      // Clear the text fields
      clearFields();
    } catch (error) {
      // ignore: use_build_context_synchronously
      await showErrorDialog(context,
          title: Text('Erro ao gravar registro  - $error'));
    }
  }
}

void callDeleteProduct(
    BuildContext context, DocumentSnapshot documentSnapshot) async {
  try {
    await _productDao.deleteProduct(context, documentSnapshot.id);

    // ignore: use_build_context_synchronously
    await showSuccessDialog(context,
        title: const Text('Produto foi apagado com sucesso!'));
  } catch (error) {
    // ignore: use_build_context_synchronously
    await showErrorDialog(context,
        title: Text('Erro ao excluir produto - $error'));
  }
}
