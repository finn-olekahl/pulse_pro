import 'package:pulse_pro/shared/models/split_day.dart';

abstract class DayEntry {
  final String workoutPlanId;
  final int splitDayNumber;
  final DateTime date;

  const DayEntry({
    required this.workoutPlanId,
    required this.splitDayNumber,
    required this.date,
  });
}

class HistoryDayEntry extends DayEntry {
  final SplitDay completedSplitDay;
  final Duration duration;

  const HistoryDayEntry({
    required super.workoutPlanId,
    required super.splitDayNumber,
    required super.date,
    required this.completedSplitDay,
    required this.duration,
  });

  factory HistoryDayEntry.fromJson(Map<String, dynamic> json) {
    return HistoryDayEntry(
      workoutPlanId: json['workout_plan_id'],
      splitDayNumber: json['split_day_number'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      completedSplitDay: SplitDay.fromJson(json['split_day_number'], json['split_day']),
      duration: Duration(milliseconds: json['duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_plan_id': workoutPlanId,
      'split_day_number': splitDayNumber,
      'date': date.millisecondsSinceEpoch,
      'split_day': completedSplitDay.toJson(),
      'duration': duration.inMilliseconds,
    };
  }
}

class PlanDayEntry extends DayEntry {

  const PlanDayEntry({
    required super.workoutPlanId,
    required super.splitDayNumber,
    required super.date,
  });

  factory PlanDayEntry.fromJson(Map<String, dynamic> json) {
    return PlanDayEntry(
      workoutPlanId: json['workout_plan_id'],
      splitDayNumber: json['split_day_number'],
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(json['date']))
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_plan_id': workoutPlanId,
      'split_day_number': splitDayNumber,
      'date': date.millisecondsSinceEpoch,
    };
  }
}
