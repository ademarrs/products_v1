import 'package:flutter/material.dart';
import 'package:products/pages/auth_check.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Catálago de produtos ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthCheck(), // const ListarProdutosPage(),
    );
  }
}
