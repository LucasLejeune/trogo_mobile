import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trogo_mobile/model/equipment.dart';

class EquipmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEquipment(
      List<Equipment> items, List<bool> selectedItems) async {
    try {
      DocumentReference userDoc =
          _firestore.collection('Users').doc('jFOaMexbbC8Y32NcK92I');
      DocumentSnapshot documentSnapshot = await userDoc.get();
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> userEquipments = userData['Equipments'];

      items.asMap().forEach((index, item) async {
        if (selectedItems[index]) {
          await userDoc.update({
            'Equipments': FieldValue.arrayUnion([item.name]),
          });
        } else if (userEquipments.contains(item.name)) {
          await userDoc.update({
            'Equipments': FieldValue.arrayRemove([item.name]),
          });
        }
      });

      print('User\'s Equipments array updated successfully');
    } catch (e) {
      print('Error updating equipment: $e');
    }
  }
}
