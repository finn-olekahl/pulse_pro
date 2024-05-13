import 'package:pulse_pro/shared/models/split_day.dart';

class DayEntry {
  final String workoutPlanId;
  final SplitDay splitDay;
  final DateTime date;

  const DayEntry({
    required this.workoutPlanId,
    required this.splitDay,
    required this.date,
  });
}
