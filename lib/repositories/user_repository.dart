import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

class UserRepository{
  Future<bool> userExists(String userId) async {
    final data = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return data.exists;
  }

  Future<void> updateWorkoutPlans(String userId, Map<String, WorkoutPlan> workoutPlans) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({'workout_plans': workoutPlans.map((key, value) => MapEntry(key, value.toJson()))});
  }
}