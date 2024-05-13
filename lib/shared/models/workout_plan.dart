import 'dart:ffi';

import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/split_day.dart';

class WorkoutPlan {
  final Goal goal;
  final Intensity intensity;
  final Long timePerDay;
  final List<String>? injuries;
  final List<MuscleGroup>? focus;
  final Map<int, SplitDay> days;

  WorkoutPlan({
    required this.goal,
    required this.intensity,
    required this.timePerDay,
    this.injuries,
    this.focus,
    required this.days,
  });
}

enum Goal {
  fatLoss,
  muscleGain,
  strengthGain,
  endurance,
}

enum Intensity { low, moderate, high, extreme }
