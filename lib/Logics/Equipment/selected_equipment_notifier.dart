import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedEquipmentsNotifier extends StateNotifier<List<bool>> {
  List<String> userEquipments = [];

  SelectedEquipmentsNotifier(int itemCount)
      : super(List.filled(itemCount, false)) {
    fetchEquipments();
  }

  Future<void> fetchEquipments() async {
    try {
      // Fetch all equipment names
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Equipments').get();
      List<String> equipmentNames =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      // Set the initial state with the count of equipment
      state = List.filled(equipmentNames.length, false);

      // Fetch user document
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc('jFOaMexbbC8Y32NcK92I');

      DocumentSnapshot documentSnapshot = await userDoc.get();
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;

      // Initialize userEquipments
      userEquipments = List<String>.from(userData['Equipments'] ?? []);

      // Update the state based on userEquipments
      for (int i = 0; i < equipmentNames.length; i++) {
        if (userEquipments.contains(equipmentNames[i])) {
          state[i] = true; // Mark as selected
        }
      }

      // Notify listeners of the state change
      state = List.from(state); // Trigger rebuild
    } catch (e) {
      print('Error fetching equipments: $e');
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
