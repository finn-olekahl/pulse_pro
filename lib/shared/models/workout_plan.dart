import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/split_day.dart';

class WorkoutPlan {
  final String id;
  final WorkoutGoal goal;
  final WorkoutIntensity intensity;
  final WorkoutExperience experience;
  final int timePerDay;
  final List<String>? injuries;
  final List<MuscleGroup>? focus;
  final SportOrientation? sportOrientation;
  final Map<int, SplitDay> days;

  WorkoutPlan({
    required this.id,
    required this.goal,
    required this.intensity,
    required this.experience,
    required this.timePerDay,
    this.injuries,
    this.focus,
    this.sportOrientation,
    required this.days,
  });

  WorkoutPlan copyWith({
    String? id,
    WorkoutGoal? goal,
    WorkoutIntensity? intensity,
    WorkoutExperience? experience,
    int? timePerDay,
    List<String>? injuries,
    List<MuscleGroup>? focus,
    SportOrientation? sportOrientation,
    Map<int, SplitDay>? days,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      intensity: intensity ?? this.intensity,
      experience: experience ?? this.experience,
      timePerDay: timePerDay ?? this.timePerDay,
      injuries: injuries ?? this.injuries,
      focus: focus ?? this.focus,
      sportOrientation: sportOrientation ?? this.sportOrientation,
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
      goal: WorkoutGoal.values.firstWhere(
          (e) => e.toString() == 'Goal.${json['params']['workout_goal']}'),
      intensity: WorkoutIntensity.values.firstWhere((e) =>
          e.toString() == 'Intensity.${json['params']['workout_intensity']}'),
      experience: WorkoutExperience.values.firstWhere((e) =>
          e.toString() == 'Experience.${json['params']['workout_experience']}'),
      timePerDay: json['params']['time_per_day'],
      injuries: json['params']['injuries']?.cast<String>(),
      focus: json['params']['muscle_focus']
          ?.map((e) => MuscleGroup.values
              .firstWhere((element) => element.toString().split('.')[1] == e))
          .toList()
          .cast<MuscleGroup>(),
      sportOrientation: SportOrientation.values.firstWhere((e) =>
          e.toString() ==
          'SportOrientation.${json['params']['sport_orientation']}'),
      days: days,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'params': {
        'workout_goal': goal.toString().split('.').last,
        'workout_intensity': intensity.toString().split('.').last,
        'workout_experience': experience.toString().split('.').last,
        'time_per_day': timePerDay,
        'injuries': injuries,
        'muscle_focus':
            focus?.map((e) => e.toString().split('.').last).toList(),
        'sport_orientation': sportOrientation.toString().split('.').last
      },
      'split':
          days.map((key, value) => MapEntry(key.toString(), value.toJson())),
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

enum Injuries {
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

enum SportOrientation {
  archery,
  badminton,
  baseball,
  basketball,
  boxing,
  climbing,
  cricket,
  crossfit,
  cycling,
  fencing,
  fieldHockey,
  football,
  golf,
  gymnastics,
  handball,
  hiking,
  hockey,
  iceHockey,
  judo,
  karate,
  kickboxing,
  lacrosse,
  martialArts,
  mountainBiking,
  netball,
  parkour,
  rowing,
  rugby,
  running,
  sailing,
  skiing,
  snowboarding,
  squash,
  surfing,
  swimming,
  tableTennis,
  taekwondo,
  tennis,
  triathlon,
  volleyball,
  waterPolo,
  weightlifting,
  wrestling
}
