import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentdriver/services/authService.dart';
import 'package:rentdriver/services/checkPage.dart';
import 'package:rentdriver/style.dart';

class SingPage extends StatefulWidget {
  const SingPage({super.key});

  @override
  State<SingPage> createState() => _SingPageState();
}

class _SingPageState extends State<SingPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nifController = TextEditingController();
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _termsAccepted = false;
  String? errorMessage;

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
              'Cadastrar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
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
            SizedBox(height: 20),
            TextFormField(
              controller: _nifController,
              decoration: InputDecoration(
                labelText: 'NIF',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (newValue) {
                    setState(() {
                      _termsAccepted = newValue!;
                    });
                  },
                ),
                Text('Termos de serviço'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cadastrar();
              },
              style: AppStyles.blackButton,
              child: Text('Cadastrar', style: AppStyles.buttonTextStyle),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: AppStyles.garyButton,
              child: Text('Já possuo conta', style: AppStyles.buttonTextStyle),
            ),
          ],
        ),
      ),
    );
  }

  cadastrar() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você deve aceitar os termos de serviço'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      User? user = await _authService.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _nomeController.text,
      );
      if (user != null) {
        await sendData(user.uid);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Checkpage()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'Crie uma senha mais forte';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Este email já possui uma conta';
      } else {
        errorMessage =
            'Erro ao tentar fazer cadastro. Todos os campos estão preenchidos corretamente?';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro desconhecido: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> sendData(String uid) async {
    await _firestore.collection("users").doc(uid).set({
      "name": _nomeController.text,
      "email": _emailController.text,
      "nif": _nifController.text,
    });
  }
}
