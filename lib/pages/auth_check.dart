import 'package:flutter/material.dart';
import 'package:products/my_application.dart';
import 'package:provider/provider.dart';
import 'package:products/pages/login_page.dart';
import 'package:products/services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    // aqui recupera a instacia do objeto de AuthService com todos os controle de usuario logada ou nao
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return const LoginPage();
    } else {
      return const MyApplication();
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
