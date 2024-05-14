import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse_pro/shared/models/exercise.dart';

class ExerciseRepository {
  final Map<String, Exercise> _cache = {};
   
  Future<Exercise?> getExercise(String exerciseId) async {
    if (_cache.containsKey(exerciseId)) return _cache[exerciseId];

    final result = await FirebaseFirestore.instance.collection('exercises').doc(exerciseId).get();
    if (!result.exists) return null;

    final exercise = Exercise.fromJson(result.data()!);
    _cache[exerciseId] = exercise;
    return exercise;
  }
}