// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_provider.dart';

final authControllerProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthController(firebaseAuth);
});

class AuthController {
  final FirebaseAuth firebaseAuth;

  AuthController(this.firebaseAuth);

  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }
}