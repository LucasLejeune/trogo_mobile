import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trogo_mobile/model/exercise.dart';
import 'package:trogo_mobile/model/workout.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailPage({required this.workoutId});

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  late Future<Workout> _workoutFuture;

  @override
  void initState() {
    super.initState();
    _workoutFuture = fetchWorkout(widget.workoutId);
  }

  Future<Workout> fetchWorkout(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Workouts').doc(id).get();

    if (snapshot.exists) {
      return Workout.fromMap(snapshot.data()!, snapshot.id);
    } else {
      throw Exception('Workout not found');
    }
  }

  void _reloadWorkout() {
    setState(() {
      _workoutFuture = fetchWorkout(widget.workoutId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _reloadWorkout,
          ),
        ],
      ),
      body: FutureBuilder<Workout>(
        future: _workoutFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No workout found.'));
          } else {
            final workout = snapshot.data!;

            return FutureBuilder<List<Exercise>>(
              future: workout.fetchExercises(),
              builder: (context, exercisesSnapshot) {
                if (exercisesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (exercisesSnapshot.hasError) {
                  return Center(
                      child: Text(
                          'Error fetching exercises: ${exercisesSnapshot.error}'));
                } else if (!exercisesSnapshot.hasData ||
                    exercisesSnapshot.data!.isEmpty) {
                  return Center(child: Text('No exercises found.'));
                } else {
                  final exercises = exercisesSnapshot.data!;

                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                workout.name,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.stopwatch,
                                    size: 15,
                                  ),
                                  Text('${workout.duration} minutes')
                                ],
                              )
                            ]),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              final exercise = exercises[index];

                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4.0),
                                      Builder(
                                        builder: (context) {
                                          return Row(
                                            children: [
                                              Text(
                                                'Difficulté: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              FaIcon(
                                                exercise.getDifficultyIcon(),
                                                size: 15,
                                              ),
                                              SizedBox(width: 2.0),
                                            ],
                                          );
                                        },
                                      ),
                                      Row(children: [
                                        Text(
                                          'Type: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          exercise.type,
                                        ),
                                      ]),
                                      SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.person,
                                            size: 15,
                                          ),
                                          SizedBox(width: 2.0),
                                          Text(
                                            'Zone(s) travaillée(s):',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      ...exercise.bodyZones
                                          .map((bodyZone) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 0),
                                                child: Text(bodyZone.name),
                                              )),
                                      SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.person,
                                            size: 15,
                                          ),
                                          SizedBox(width: 2.0),
                                          Text(
                                            'Muscle(s) solicité(s):',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      ...exercise.muscles
                                          .map((muscle) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 0),
                                                child: Text(muscle.name),
                                              )),
                                      SizedBox(height: 4.0),
                                      Builder(
                                        builder: (context) {
                                          if (exercise.equipment.isNotEmpty) {
                                            return Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.dumbbell,
                                                  size: 15,
                                                ),
                                                SizedBox(width: 2.0),
                                                Text(
                                                  'Equipment nécessaire:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                      SizedBox(height: 4.0),
                                      ...exercise.equipment
                                          .map((equipment) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 0),
                                                child: Text(equipment.name),
                                              )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
