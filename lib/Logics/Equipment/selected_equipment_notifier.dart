import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedEquipmentsNotifier extends StateNotifier<List<bool>> {
  List<String> userEquipments = [];
  User? currentUser = FirebaseAuth.instance.currentUser;

  SelectedEquipmentsNotifier(int itemCount)
      : super(List.filled(itemCount, false)) {
    fetchEquipments();
  }

  Future<void> fetchEquipments() async {
    if (currentUser != null) {
      try {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('Equipments').get();
        List<String> equipmentNames =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
        state = List.filled(equipmentNames.length, false);

        DocumentReference userDoc = FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser?.uid);

        DocumentSnapshot documentSnapshot = await userDoc.get();
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;

        userEquipments = List<String>.from(userData['Equipments'] ?? []);

        for (int i = 0; i < equipmentNames.length; i++) {
          if (userEquipments.contains(equipmentNames[i])) {
            state[i] = true;
          }
        }

        state = List.from(state);
      } catch (e) {
        print('Error fetching equipments: $e');
      }
    }
  }

  void toggleSelection(int index, String equipmentName) {
    state[index] = !state[index];
    state = List.from(state);

    if (state[index]) {
      userEquipments.add(equipmentName);
    } else {
      userEquipments.remove(equipmentName);
    }
  }

  List<String> get selectedEquipments => userEquipments;

  void setItemCount(int count) {
    state = List.filled(count, false);
    userEquipments.clear();
  }

  List<String> getSelectedEquipment() {
    return userEquipments;
  }
}

final selectedItemsProvider =
    StateNotifierProvider.family<SelectedEquipmentsNotifier, List<bool>, int>(
  (ref, itemCount) {
    return SelectedEquipmentsNotifier(itemCount);
  },
);
