import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trogo_mobile/model/equipment.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EquipmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> addEquipment(
      List<Equipment> items, List<bool> selectedItems) async {
    if (currentUser != null) {
      try {
        DocumentReference userDoc =
            _firestore.collection('Users').doc(currentUser?.uid);
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
        Fluttertoast.showToast(
            msg: "Equipement mis à jour",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
            webBgColor: "black");
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Une erreur est survenue",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.red,
            fontSize: 16.0,
            webBgColor: "black");
      }
    }
  }
}
