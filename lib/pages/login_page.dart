import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:products/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  String titulo = 'Bem Vindo';
  String actionButton = 'Login';
  String troggleButton = 'Para fazer aleraçãoes nos dados faça login';

  @override
  void initState() {
    super.initState();
    //   setFormAction(true);
  }

  // Ademar - esta rotina faz com seja solcitado o cadastro de uma nova conta,
  // para este app a conta deverá ser cadastrada direto no firebase
  // setFormAction(bool acao) {
  //   isLogin = acao;

  //   if (isLogin) {
  //     titulo = 'Bem Vindo';
  //     actionButton = 'Login';
  //     troggleButton = 'Ainda não tem conta? Cadastre-se agora.';
  //   } else {
  //     titulo = 'Crie Sua Conta';
  //     actionButton = 'Cadastrar';
  //     troggleButton = 'Voltar ao Login.';
  //   }
  //   setState(() {});
  // }

  login() async {
    setState(() => isLoading = true);
    try {
      await context.read<AuthService>().login(email.text, senha.text);
      setState(() => isLoading = false);
    } on AuthException catch (e) {
      setState(() => isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
    setState(() => isLoading = false);
  }

  guestLogin() async {
    setState(() => isLoading = true);
    try {
      await context.read<AuthService>().login('guest@email.com', '123456');
      setState(() => isLoading = false);
    } on AuthException catch (e) {
      setState(() => isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
    setState(() => isLoading = false);
  }

  registrar() async {
    setState(() => isLoading = true);
    try {
      await context.read<AuthService>().registrar(email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-Mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o e-mail corretamente.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextFormField(
                      controller: senha,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe a senha corretamente.';
                        } else if (value.length < 6) {
                          return 'A senha deve ter no mínimo 6 cartacteres.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade300),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (isLogin) {
                                  login();
                                } else {
                                  registrar();
                                }
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: (isLoading)
                                  ? [
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ]
                                  : [
                                      const Icon(
                                        Icons.check,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          actionButton,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      )
                                    ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade900),
                            onPressed: () {
                              guestLogin();
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Consultar',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                  ),
                  //  TextButton(
                  //    onPressed: () => setFormAction(!isLogin),
                  //    child: Text(troggleButton),
                  //  ),
                ],
              ),
            )),
      ),
    );
  }
}
