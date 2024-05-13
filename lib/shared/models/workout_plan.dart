import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/split_day.dart';

class WorkoutPlan {
  final String id;
  final Goal goal;
  final Intensity intensity;
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
    Goal? goal,
    Intensity? intensity,
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

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    Map<int, SplitDay> days = {};
    if (json['split'] != null) {
      json['split'].forEach((key , value) {
        days[int.parse(key)] = SplitDay.fromJson(value);
      });
    }

    return WorkoutPlan(
      id: json['id'],
      goal: Goal.values[json['params']['workout_goal']],
      intensity: Intensity.values[json['params']['workout_intensity']],
      timePerDay: int.parse(json['params']['time_per_day']),
      injuries: json['params']['injuries'],
      focus: json['params']['muscle_focus'],
      days: days,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'params': {
        'workout_goal': goal.index,
        'workout_intensity': intensity.index,
        'time_per_day': timePerDay,
        'injuries': injuries,
        'muscle_focus': focus?.map((e) => e.toString().split('.').last).toList(),
      },
      'split': days.map((key, value) => MapEntry(key.toString(), value.toJson())),
    };
  }
}

enum Goal {
  fatLoss,
  muscleGain,
  strengthGain,
  endurance,
}

enum Intensity { low, moderate, high, extreme }
