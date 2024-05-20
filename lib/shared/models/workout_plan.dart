import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/split_day.dart';

class WorkoutPlan {
  final String id;
  final WorkoutGoal goal;
  final WorkoutIntensity intensity;
  final int timePerDay;
  final List<String>? injuries;
  final List<MuscleGroup>? focus;
  final Map<int, SplitDay> days;

  WorkoutPlan({
    required this.id,
    required this.goal,
    required this.intensity,
    required this.timePerDay,
    this.injuries,
    this.focus,
    required this.days,
  });

  WorkoutPlan copyWith({
    String? id,
    WorkoutGoal? goal,
    WorkoutIntensity? intensity,
    int? timePerDay,
    List<String>? injuries,
    List<MuscleGroup>? focus,
    Map<int, SplitDay>? days,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      intensity: intensity ?? this.intensity,
      timePerDay: timePerDay ?? this.timePerDay,
      injuries: injuries ?? this.injuries,
      focus: focus ?? this.focus,
      days: days ?? this.days,
    );
  }

  factory WorkoutPlan.fromJson(String id, Map<String, dynamic> json) {
    Map<int, SplitDay> days = {};
    if (json['split'] != null) {
      json['split'].forEach((key, value) {
        days[int.parse(key)] = SplitDay.fromJson(value);
      });
    }

    return WorkoutPlan(
      id: id,
      goal: WorkoutGoal.values.firstWhere((e) => e.toString() == 'WorkoutGoal.${json['params']['workout_goal']}'),
      intensity: WorkoutIntensity.values
          .firstWhere((e) => e.toString() == 'WorkoutIntensity.${json['params']['workout_intensity']}'),
      timePerDay: json['params']['time_per_day'],
      injuries: json['params']['injuries']?.cast<String>(),
      focus: json['params']['muscle_focus']
          ?.map((e) => MuscleGroup.values.firstWhere((element) => element.toString().split('.')[1] == e))
          .toList()
          .cast<MuscleGroup>(),
      days: days,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'params': {
        'workout_goal': goal.toString().split('.').last,
        'workout_intensity': intensity.toString().split('.').last,
        'time_per_day': timePerDay,
        'injuries': injuries,
        'muscle_focus': focus?.map((e) => e.toString().split('.').last).toList(),
      },
      'split': days.map((key, value) => MapEntry(key.toString(), value.toJson())),
    };
  }
}

enum WorkoutGoal {
  fatLoss,
  muscleGain,
  strengthGain,
  endurance,
}

enum WorkoutIntensity { low, moderate, high, extreme }

enum WorkoutExperience { beginner, intermediate, expert }

enum Injury {
  head,
  neck,
  shoulder,
  upperBack,
  lowerBack,
  chest,
  upperArm,
  elbow,
  forearm,
  wrist,
  hand,
  fingers,
  hip,
  thigh,
  knee,
  lowerLeg,
  ankle,
  foot,
  toes,
}

