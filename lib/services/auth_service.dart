import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../utils/error_dialog.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario; // usuario interno do sistema
  String? typeUser; // define o tipo do usuario, se é administrador ou convidado
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    // user - retorna o usuario do firebase
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      ErrorDialog.showErrorDialog(
          context as BuildContext, 'Erro a criar usuario ${e.toString()}');
    }
  }

  _getUser() {
    usuario = _auth.currentUser;

    if (usuario?.email == null) {
      typeUser = 'guest';
    } else {
      if (usuario!.email!.startsWith('guest')) {
        typeUser = 'guest';
      } else {
        typeUser = 'admin';
      }
    }
    notifyListeners();
  }

  registrar(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' || e.code == 'user-not-found') {
        throw AuthException('E-mail não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      } else {
        throw AuthException(e.code);
      }
    }
  }

  logout() async {
    if (typeUser == 'guest') {
      await _auth.signOut();
    } else {
      usuario!.email!.startsWith('guest');
      typeUser = 'guest';
    }
    notifyListeners();
  }
}
