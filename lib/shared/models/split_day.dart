import 'dart:ffi';
import 'package:pulse_pro/features/trainings_plan/view/plan_view.dart';
import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/warmup.dart';

class SplitDay {
  final bool restDay;
  final List<MuscleGroup>? target;
  final Long? timeBetweenSets;
  final List<Exercise>? exercises;
  final WarmUp? warmUp;

  SplitDay({
    required this.restDay,
    this.target,
    this.timeBetweenSets,
    this.exercises,
    this.warmUp,
  });

}

