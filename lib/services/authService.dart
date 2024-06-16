import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user!.updateDisplayName(name);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
