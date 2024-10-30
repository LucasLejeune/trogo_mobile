// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_provider.dart';

final authControllerProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthController(firebaseAuth);
});

class AuthController {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthController(this.firebaseAuth);

  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUser(userCredential.user!);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> logIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
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

  Future<void> createUser(User user) async {
    try {
      await _firestore.collection('Users').doc(user.uid).set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'Equipments': FieldValue.arrayUnion([]),
      });
    } catch (e) {
      print('Error creating user data: $e');
    }
  }
}
