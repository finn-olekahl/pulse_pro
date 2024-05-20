import 'package:pulse_pro/shared/models/day_entry.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

class PulseProUser {
  final String id;
  final String name;
  final String email;
  final DateTime birthDate;
  final Gender gender;
  final int weight;
  final int height;
  final int streak;
  final String currentWorkoutPlan;
  final Map<String, WorkoutPlan> workoutPlans;
  final List<HistoryDayEntry> history;
  final List<PlanDayEntry> plan;

  PulseProUser({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.weight,
    required this.height,
    required this.streak,
    required this.currentWorkoutPlan,
    required this.workoutPlans,
    required this.history,
    required this.plan,
  });

  factory PulseProUser.fromJson(Map<String, dynamic> json) {
    Map<String, WorkoutPlan> workoutPlans = {};
    if (json['workout_plans'] != null) {
      json['workout_plans'].forEach((key, value) {
        workoutPlans[key] = WorkoutPlan.fromJson(key, value);
      });
    }

    List<HistoryDayEntry> history = [];
    if (json['history'] != null) {
      history = json['history']
          .map((item) => HistoryDayEntry.fromJson(item))
          .toList();
    }

    List<PlanDayEntry> plan = [];
    if (json['plan'] != null) {
      plan = json['plan'].map((item) => PlanDayEntry.fromJson(item)).toList();
    }

    return PulseProUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      birthDate: DateTime.fromMillisecondsSinceEpoch(json['birthdate']),
      gender: Gender.values.firstWhere(
          (e) => e.toString() == 'Gender.${json['gender']}',
          orElse: () => Gender.male),
      weight: json['weight'],
      height: json['height'],
      streak: json['streak'],
      currentWorkoutPlan: json['current_workout_plan'],
      workoutPlans: workoutPlans,
      history: history,
      plan: plan,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'birthdate': birthDate.millisecondsSinceEpoch,
      'gender': gender.toString().split('.').last,
      'weight': weight,
      'height': height,
      'streak': streak,
      'current_workout_plan': currentWorkoutPlan,
      'workout_plans':
          workoutPlans.map((key, value) => MapEntry(key, value.toJson())),
      'history': history.map((e) => e.toJson()).toList(),
      'plan': plan.map((e) => e.toJson()).toList(),
    };
  }
}

enum Gender { male, female }
