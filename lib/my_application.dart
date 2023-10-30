import 'package:flutter/material.dart';
import 'package:products/pages/product_home_page.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Catalago de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const ProductHomePage(), // ListarProdutosPage(),
    );
  }
}
