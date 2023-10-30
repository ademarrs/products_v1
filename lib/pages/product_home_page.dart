import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:products/dao/product_dao.dart';
import 'package:products/pages/create_or_update_product.dart';
import 'package:products/services/auth_service.dart';
import 'package:products/utils/csv_utils.dart';
import 'package:products/utils/replace_accents.dart';
import 'package:products/utils/show_dialogs.dart';
import 'package:provider/provider.dart';

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({Key? key}) : super(key: key);

  @override
  State<ProductHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<ProductHomePage> {
  //final _formKey = GlobalKey<FormState>();

  final TextEditingController _searchController = TextEditingController();

  // esse campo filter, será digitado pelo usuario para filtrar os produtos
  String filter = '';

  void _handleOpenCSVClick() async {
    final ProductDao productDao = ProductDao();
    int rowCount = 0;
    List<List<dynamic>> csvData = await CsvUtils.openAndProcessCSV();

    if (csvData.isNotEmpty) {
      for (var row in csvData) {
        if (row.isNotEmpty && rowCount > 0) {
          await productDao.insertProduct(row[0], row[1], 0, true, '');
        }
        rowCount++;
      }
    } else {
      // Lida com o caso em que nenhum arquivo foi escolhido
    }
  }

  myTitleAppBar() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Digite o produto para pesquisa . . . ',
        hintStyle: const TextStyle(color: Colors.white54),
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(1.0),
          child: IconButton(
            icon: const Icon(Icons.cancel_rounded),
            onPressed: () {
              _searchController.clear();
              setState(() {
                filter = _searchController.text;
              });
            },
          ),
        ),
      ),
      onChanged: (value) {
        setState(() {
          filter = value.toLowerCase();
          filter = replaceAccents(filter);
        });
      },
    );
  }

  myAppBar(AuthService auth) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: myTitleAppBar(),
      actions: [
        PopupMenuButton(
            itemBuilder: (_) => [
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.file_open),
                      title: const Text('Carregar CSV'),
                      onTap: () {
                        _handleOpenCSVClick();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Logout'),
                      onTap: () {
                        Navigator.pop(context);
                        auth.logout();
                      },
                    ),
                  )
                ]),
      ],
    );
  }

  editButton(DocumentSnapshot documentSnapshot, AuthService auth) {
    return IconButton(
        icon: Icon(auth.typeUser == 'admin' ? Icons.edit : null),
        tooltip: auth.typeUser == 'admin' ? 'Alterar o item' : '',
        onPressed: auth.typeUser != 'admin'
            ? null
            : () {
                createOrUpdateProduct(
                    context, auth.usuario!.email, documentSnapshot);
              });
  }

  deleteButton(DocumentSnapshot documentSnapshot, AuthService auth) {
    return IconButton(
      icon: Icon(auth.typeUser == 'admin' ? Icons.delete : null),
      tooltip: auth.typeUser == 'admin' ? 'Excluir o item' : '',
      onPressed: auth.typeUser != 'admin'
          ? null
          : () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteConfirmationDialog(
                    dialogTitle: 'Exclusão',
                    dialogContent:
                        'Confirma a exclusão do item ${documentSnapshot['name']}?',
                    onDeleteConfirmed: () {
                      callDeleteProduct(context, documentSnapshot);
                    },
                  );
                },
              );
            },
    );
  }

  myBodyBuild(AuthService auth) {
    return StreamBuilder(
      stream: productss
          // ${filter}z') - a letra z faz parte da regra para fazer a pesquisa corretamente
          .orderBy('lowercasename')
          .where('lowercasename', isGreaterThanOrEqualTo: filter)
          .where('lowercasename', isLessThan: '${filter}z')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!streamSnapshot.hasData) {
          return const Center(
            child: Text('Não foram encontrados produtos!'),
          );
        }
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                      '${documentSnapshot['name']}  - Saldo: ${documentSnapshot['balance']}'),
                  subtitle: Text(documentSnapshot['detailed_name']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(children: [
                      editButton(documentSnapshot, auth),
                      deleteButton(documentSnapshot, auth),
                    ]),
                  ),
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: myAppBar(auth),
      body: myBodyBuild(auth),
      floatingActionButton: (auth.typeUser != 'admin')
          ? null
          : FloatingActionButton(
              onPressed: () =>
                  createOrUpdateProduct(context, auth.usuario!.email),
              child: const Icon(Icons.add),
            ),
      //}
    );
  }
}
