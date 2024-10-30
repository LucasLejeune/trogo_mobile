import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trogo_mobile/model/exercise.dart';

class Workout {
  final String id;
  final String name;
  final int duration;
  final List<DocumentReference> exerciseRefs;

  Workout(this.duration,
      {required this.id, required this.name, required this.exerciseRefs});

  factory Workout.fromMap(Map<String, dynamic> data, String id) {
    var exerciseList = data['Exercices'] as List;
    List<DocumentReference> exerciseRefs =
        exerciseList.map((ref) => ref as DocumentReference).toList();
    return Workout(
      data['duration'],
      id: id,
      name: data['name'] ?? '',
      exerciseRefs: exerciseRefs,
    );
  }

  Future<List<Exercise>> fetchExercises() async {
    List<Exercise> exercises = [];
    for (var ref in exerciseRefs) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          (await ref.get()) as DocumentSnapshot<Map<String, dynamic>>;
      if (snapshot.exists) {
        exercises.add(Exercise.fromMap(snapshot.data()!));
      }
    }
    return exercises;
  }
}
