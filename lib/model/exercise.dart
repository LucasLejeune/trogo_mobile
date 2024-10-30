import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trogo_mobile/model/body_zone.dart';
import 'package:trogo_mobile/model/equipment.dart';
import 'package:trogo_mobile/model/muscle.dart';

class Exercise {
  final String name;
  final String type;
  final String difficulty;
  final List<BodyZone> bodyZones;
  final List<Equipment> equipment;
  final List<Muscle> muscles;

  Exercise({
    required this.name,
    required this.type,
    required this.difficulty,
    required this.bodyZones,
    required this.equipment,
    required this.muscles,
  });

  factory Exercise.fromMap(Map<String, dynamic> data) {
    var bodyZoneList = data['BodyZones'] as List<dynamic>? ?? [];
    var equipmentList = data['Equipment'] as List<dynamic>? ?? [];
    var muscleList = data['Muscles'] as List<dynamic>? ?? [];

    List<BodyZone> bodyZones = bodyZoneList
        .where((zoneData) => zoneData is String)
        .map((zoneData) => BodyZone(name: zoneData))
        .toList();

    List<Equipment> equipment = equipmentList
        .where((equipmentData) => equipmentData is String)
        .map((equipmentData) => Equipment(name: equipmentData))
        .toList();

    List<Muscle> muscles = muscleList
        .where((muscleData) => muscleData is String)
        .map((muscleData) => Muscle(name: muscleData))
        .toList();

    return Exercise(
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      difficulty: data['difficulty'] ?? '',
      bodyZones: bodyZones,
      equipment: equipment,
      muscles: muscles,
    );
  }

  IconData getDifficultyIcon() {
    if (difficulty == "Débutant") {
      return FontAwesomeIcons.starHalf;
    } else if (difficulty == "Intermédiaire") {
      return FontAwesomeIcons.star;
    }
    return FontAwesomeIcons.solidStar;
  }

  static IconData getDifficultyIconFromString(String difficulty) {
    if (difficulty == "Débutant") {
      return FontAwesomeIcons.starHalf;
    } else if (difficulty == "Intermédiaire") {
      return FontAwesomeIcons.star;
    }
    return FontAwesomeIcons.solidStar;
  }
}
