import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentdriver/services/authService.dart';
import 'package:rentdriver/pages/homePage.dart';
import 'package:rentdriver/pages/singPage.dart';
import 'package:rentdriver/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Palavra-passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Lógica para esquecer a senha
                },
                child: Text('Esqueci minha palavra-passe'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                login();
              },
              style: AppStyles.blackButton,
              child: Text('Entrar', style: AppStyles.buttonTextStyle),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SingPage()));
              },
              style: AppStyles.garyButton,
              child: Text('Não tenho conta', style: AppStyles.buttonTextStyle),
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    try {
      User? user = await _authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Usuário não encontrado';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Sua palavra passe está incorreta';
      } else {
        errorMessage =
            'Erro ao tentar fazer login. Tente novamente mais tarde.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
