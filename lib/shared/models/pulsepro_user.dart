import 'package:pulse_pro/features/trainings_plan/view/plan_view.dart';
import 'package:pulse_pro/shared/models/day_entry.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

class PulseProUser {
  final String name;
  final String email;
  final DateTime birthDate;
  final int weight;
  final int height;
  final int streak;
  final String currentWorkoutPlan;
  final Map<String, WorkoutPlan> workoutPlans;
  final List<Exercise> exercises;
  final List<DayEntry> history;
  final List<DayEntry> plan;

  PulseProUser({
    required this.name,
    required this.email,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.streak,
    required this.currentWorkoutPlan,
    required this.workoutPlans,
    required this.exercises,
    required this.history,
    required this.plan,
  });

  factory PulseProUser.fromMap(Map<String, dynamic> map) {
    return PulseProUser();
  }
}
