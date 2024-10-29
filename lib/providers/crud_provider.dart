import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final userProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(firestoreProvider).collection('user').snapshots();
});

class UserService {
  final FirebaseFirestore firestore;

  UserService(this.firestore);

  Future<void> addUser(String name, String email) async {
    await firestore.collection('user').add({
      'name': name,
      'email': email,
    });
  }

  Future<void> updateUser(String id, String name) async {
    await firestore.collection('user').doc(id).update({
      'name': name,
    });
  }

  Future<void> deleteUser(String id) async {
    await firestore.collection('user').doc(id).delete();
  }
}

final userServiceProvider = Provider((ref) {
  return UserService(ref.watch(firestoreProvider));
});