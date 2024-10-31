import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trogo_mobile/model/workout.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchWorkouts() async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Workouts').get();
      return querySnapshot.docs;
    }

    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection('Users')
        .doc(currentUser.uid)
        .get();

    List<dynamic> userEquipment = userDoc.data()?['Equipments'] ?? [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Workouts').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredWorkouts = [];

    for (var workoutDoc in querySnapshot.docs) {
      List<dynamic> workoutEquipments = [];

      for (var ref in workoutDoc.data()['Exercices']) {
        DocumentSnapshot<Map<String, dynamic>> exerciseDoc = await ref.get();
        List<dynamic> exerciseEquipments =
            exerciseDoc.data()?['Equipment'] ?? [];

        workoutEquipments.addAll(exerciseEquipments);
      }

      if (workoutEquipments
          .any((equipment) => !userEquipment.contains(equipment))) {
        print('excluded workout ${workoutDoc.id}');
      } else {
        filteredWorkouts.add(workoutDoc);
      }
    }

    return filteredWorkouts;
  }

  Future<List<Map<String, dynamic>>> fetchEquipments() async {
    QuerySnapshot snapshot = await _firestore.collection('Workouts').get();
    inspect(snapshot.docs);
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<Workout> getWorkout(String workoutId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('Workouts').doc(workoutId).get();
    return Workout.fromMap(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }
}
