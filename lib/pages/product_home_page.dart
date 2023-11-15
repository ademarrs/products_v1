import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:products/dao/product_dao.dart';
import 'package:products/pages/create_or_update_product.dart';
import 'package:products/services/auth_service.dart';
import 'package:products/utils/csv_utils.dart';
import 'package:products/utils/replace_accents.dart';
import 'package:products/utils/show_dialogs.dart';
//import 'package:products/utils/show_product_image.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:standard_dialogs/widgets/await_dialog.dart';

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({Key? key}) : super(key: key);

  @override
  State<ProductHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<ProductHomePage> {
  //final _formKey = GlobalKey<FormState>();

  final TextEditingController _searchController = TextEditingController();
  late XFile? imageXFile;

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
                  leading: showProductSmallImage(), // imagem do lado esquerdo
                  trailing:
                      (auth.typeUser != 'admin') // icones do lado diretiro
                          ? null
                          : SizedBox(
                              width: 144,
                              height: 200,
                              child: Row(children: [
                                editButton(documentSnapshot, auth),
                                cameraButton(documentSnapshot, auth),
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

  editButton(DocumentSnapshot documentSnapshot, AuthService auth) {
    return IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Alterar o item',
        onPressed: () {
          createOrUpdateProduct(context, auth.usuario!.email, documentSnapshot);
        });
  }

  cameraButton(
    DocumentSnapshot<Object?> documentSnapshot,
    AuthService auth,
  ) {
    return IconButton(
      icon: const Icon(Icons.camera_alt_outlined),
      tooltip: 'Imagem do Item',
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text(
                "Adicionar imagem ao item",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    captureImageWithCamera(context);
                  },
                  child: const Text(
                    "Capturar imagem com a câmera",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    pickImageFromGallery(context);
                  },
                  child: const Text(
                    "Selecionar imagem da galeria",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SimpleDialogOption(
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  deleteButton(DocumentSnapshot documentSnapshot, AuthService auth) {
    return IconButton(
      icon: Icon(Icons.delete),
      tooltip: 'Excluir o item',
      onPressed: () {
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

  Future<void> captureImageWithCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    Navigator.pop(context);
    XFile? capturedImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
      maxHeight: 720,
      imageQuality: 80,
    );

    if (capturedImage != null) {
      setState(() {
        imageXFile = capturedImage;
      });
    }
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    Navigator.pop(context);
    XFile? capturedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 720,
      imageQuality: 80,
    );

    if (capturedImage != null) {
      setState(() {
        imageXFile = capturedImage;
      });
    }
  }

  showProductSmallImage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: 90,
        height: 90,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset('images/Splash.png', fit: BoxFit.cover)),
        // Image(image: FileImage(File(imageXFile!.path)))
      ),
    );
  }
}
