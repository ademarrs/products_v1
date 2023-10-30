import 'package:flutter/material.dart';
import 'package:products/config.dart';
import 'package:products/main_app.dart';
// import 'package:products/pages/product_home_page.dart';
import 'package:products/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  await initConfigurations();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
    ],
    child: const MainApp(),
  ));
}



// void main() async {
//   await initConfigurations();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       // Remove the debug banner
//       debugShowCheckedModeBanner: false,
//       title: 'Produtos',
//       home: ProductHomePage(),
//     );
//   }
// }
