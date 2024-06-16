import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentdriver/pages/homePage.dart';
import 'package:rentdriver/pages/loginPage.dart';

class Checkpage extends StatefulWidget {
  const Checkpage({super.key});

  @override
  State<Checkpage> createState() => _CheckpageState();
}

class _CheckpageState extends State<Checkpage> {
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  void dispose() {
    streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
