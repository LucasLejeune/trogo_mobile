import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllWorkoutsScreen extends StatelessWidget {
  // Fetch workouts from Firestore
  Future<List<DocumentSnapshot>> fetchWorkouts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Workouts').get();
    return snapshot.docs; // Return the list of documents
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading workouts'));
          } else {
            final workouts = snapshot.data ?? [];
            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                final exerciseRefs = (workout['Exercices'] as List<dynamic>?)
                    ?.map((ref) => ref as DocumentReference<Object?>)
                    .toList();
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: exerciseRefs != null
                      ? fetchExercises(exerciseRefs)
                      : Future.value([]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text(workout['name'] ?? 'Unnamed Workout'),
                        subtitle: Text('Loading exercises...'),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text(workout['name'] ?? 'Unnamed Workout'),
                        subtitle: Text('Error loading exercises'),
                      );
                    } else {
                      final exercises = snapshot.data ?? [];
                      print(snapshot.data);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(workout['name'] ?? 'Unnamed Workout',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8.0),
                              if (exercises.isNotEmpty) ...[
                                SizedBox(height: 4.0),
                                ...exercises
                                    .map((exercise) => Text(
                                        exercise['name'] ?? 'Unnamed Exercise'))
                                    .toList(),
                              ] else ...[
                                Text('No exercises available'),
                              ],
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchExercises(
      List<DocumentReference<Object?>> exerciseRefs) async {
    List<Map<String, dynamic>> exercisesList = [];
    for (var ref in exerciseRefs) {
      DocumentSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        exercisesList.add(snapshot.data() as Map<String, dynamic>);
      }
    }
    return exercisesList;
  }
}
