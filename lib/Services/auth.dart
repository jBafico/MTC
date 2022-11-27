import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // update email
  Future updateEmail(String email) async {
    await _auth.currentUser!.updateEmail(email);
  }

// update password
  Future updatePassword(String password) async {
    await _auth.currentUser!.updatePassword(password);
  }

  // sign out
  Future signOut() async {
    await _auth.signOut();
  }
}
