import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/widgets.dart';
import 'package:pulse_pro/main.dart';

class Exercise {
  final String id;
  final String name;
  final String bodyParty;
  final String target;
  final List<String> secondaryMuscle;
  final String equipment;
  final ImageProvider gif;
  final List<String> instructions;

  const Exercise({
    required this.id,
    required this.name,
    required this.bodyParty,
    required this.target,
    required this.secondaryMuscle,
    required this.equipment,
    required this.gif,
    required this.instructions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      bodyParty: json['bodyPart'],
      target: json['target'],
      secondaryMuscle: json['secondaryMuscles'].cast<String>(),
      equipment: json['equipment'],
      gif: FirebaseImageProvider(FirebaseUrl('${PulseProApp.storageUrl}/gifs/${json['id']}')),
      instructions: json['instructions'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyParty,
      'target': target,
      'secondaryMuscles': secondaryMuscle,
      'equipment': equipment,
      'instructions': instructions,
    };
  }
}
