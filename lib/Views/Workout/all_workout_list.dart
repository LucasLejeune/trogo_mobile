import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trogo_mobile/Logics/Workout/workout_service.dart';
import 'package:trogo_mobile/Views/Workout/workout_screen.dart';
import 'package:trogo_mobile/model/exercise.dart';
import 'package:trogo_mobile/model/workout.dart';

class AllWorkoutsScreen extends StatelessWidget {
  final WorkoutService _workoutService = WorkoutService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrainements'),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _workoutService.fetchWorkouts(),
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

                final workoutData = workout.data() as Map<String, dynamic>?;

                if (workoutData == null) {
                  return ListTile(
                    title: Text('Unnamed Workout'),
                    subtitle: Text('No data available'),
                  );
                }

                final exerciseRefs =
                    (workoutData['Exercices'] as List<dynamic>?)
                            ?.cast<DocumentReference<Map<String, dynamic>>>()
                            .toList() ??
                        [];

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchExercises(exerciseRefs),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text(workoutData['name'] ?? 'Unnamed Workout'),
                        subtitle: Text('Loading exercises...'),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text(workoutData['name'] ?? 'Unnamed Workout'),
                        subtitle: Text('Error loading exercises'),
                      );
                    } else {
                      final exercises = snapshot.data ?? [];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutDetailPage(workoutId: workout.id),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(workoutData['name'] ?? 'Unnamed Workout',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(height: 2.0),
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.stopwatch,
                                      size: 15,
                                    ),
                                    Text(' ${workoutData['duration']} minutes'),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                if (exercises.isNotEmpty) ...[
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.personRunning,
                                        size: 15,
                                      ),
                                      SizedBox(width: 2.0),
                                      Text(
                                        'Exercices:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  ...exercises.map((exercise) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 0),
                                      child: Row(
                                        children: [
                                          Text(exercise['name']),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          FaIcon(
                                            Exercise
                                                .getDifficultyIconFromString(
                                                    exercise['difficulty']),
                                            size: 15,
                                          )
                                        ],
                                      ))),
                                ] else ...[
                                  Text('No exercises available'),
                                ],
                              ],
                            ),
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

// Function to fetch exercises based on DocumentReferences
  Future<List<Map<String, dynamic>>> fetchExercises(
      List<DocumentReference<Map<String, dynamic>>> exerciseRefs) async {
    List<Map<String, dynamic>> exercises = [];

    for (var ref in exerciseRefs) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
      if (snapshot.exists) {
        exercises.add(snapshot.data()!);
      }
    }

    return exercises;
  }
}
