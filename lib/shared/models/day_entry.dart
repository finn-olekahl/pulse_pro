import 'package:pulse_pro/shared/models/split_day.dart';

abstract class DayEntry {
  final String workoutPlanId;
  final DateTime date;

  const DayEntry({
    required this.workoutPlanId,
    required this.date,
  });
}

class HistoryDayEntry extends DayEntry {
  final SplitDay completedSplitDay;

  const HistoryDayEntry({
    required super.workoutPlanId,
    required super.date,
    required this.completedSplitDay,
  });

  factory HistoryDayEntry.fromJson(Map<String, dynamic> json) {
    return HistoryDayEntry(
      workoutPlanId: json['workout_plan_id'],
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(json['date'])),
      completedSplitDay: SplitDay.fromJson(json['split_day']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_plan_id': workoutPlanId,
      'date': date.millisecondsSinceEpoch,
      'split_day': completedSplitDay.toJson(),
    };
  }
}

class PlanDayEntry extends DayEntry {
  final int plannedSplitDay;

  const PlanDayEntry({
    required super.workoutPlanId,
    required super.date,
    required this.plannedSplitDay,
  });

  factory PlanDayEntry.fromJson(Map<String, dynamic> json) {
    return PlanDayEntry(
      workoutPlanId: json['workout_plan_id'],
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(json['date'])),
      plannedSplitDay: json['split_day'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_plan_id': workoutPlanId,
      'date': date.millisecondsSinceEpoch,
      'split_day': plannedSplitDay,
    };
  }
}