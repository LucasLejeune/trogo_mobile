import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trogo_mobile/model/equipment.dart';

final gameListProvider = StateProvider((ref) => []);

final fireStoreProvider =
    StateNotifierProvider<FirestoreNotifier, FirebaseFirestore>(
        (ref) => FirestoreNotifier(ref));

class FirestoreNotifier extends StateNotifier<FirebaseFirestore> {
  Ref ref;
  FirestoreNotifier(this.ref) : super(FirebaseFirestore.instance);

  Future<void> getFromFirestore(Equipment equipment) async {
    state.collection('equipments').get();
  }
}
