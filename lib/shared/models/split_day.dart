import 'package:pulse_pro/shared/models/user_exercise.dart';
import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/warmup.dart';

class SplitDay {
  final bool restDay;
  final List<MuscleGroup>? target;
  final int? timeBetweenExercises;
  final List<UserExercise>? exercises;
  final WarmUp? warmUp;

  SplitDay({
    required this.restDay,
    this.target,
    this.timeBetweenExercises,
    this.exercises,
    this.warmUp,
  });

  SplitDay copyWith({
    bool? restDay,
    List<MuscleGroup>? target,
    int? timeBetweenExercises,
    List<UserExercise>? exercises,
    WarmUp? warmUp,
  }) {
    return SplitDay(
      restDay: restDay ?? this.restDay,
      target: target ?? this.target,
      timeBetweenExercises: timeBetweenExercises ?? this.timeBetweenExercises,
      exercises: exercises ?? this.exercises,
      warmUp: warmUp ?? this.warmUp,
    );
  }

  factory SplitDay.fromJson(Map<String, dynamic> json) {
    return SplitDay(
      restDay: json['restday'],
      target: json['target']
          ?.map((item) => MuscleGroup.values.firstWhere((e) => e.toString() == 'MuscleGroup.$item'))
          .toList()
          .cast<MuscleGroup>(),
      timeBetweenExercises: json['time_between_exercises'],
      exercises: json['exercises']?.map((item) => UserExercise.fromJson(item)).toList().cast<UserExercise>(),
      warmUp: json['warm_up'] != null ? WarmUp.fromJson(json['warm_up']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restday': restDay,
      'target': target?.map((e) => e.toString().split('.').last).toList(),
      'time_between_exercises': timeBetweenExercises,
      'exercises': exercises?.map((e) => e.toJson()).toList(),
      'warm_up': warmUp?.toJson(),
    };
  }
}
