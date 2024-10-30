import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchEquipments() async {
    QuerySnapshot snapshot = await _firestore.collection('Workouts').get();
    inspect(snapshot.docs);
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
