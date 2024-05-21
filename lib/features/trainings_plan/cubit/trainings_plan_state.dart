part of 'trainings_plan_cubit.dart';

enum TrainingsPlanStatus { loading, loaded }

class TrainingsPlanState extends Equatable {
  const TrainingsPlanState._(
      {this.status = TrainingsPlanStatus.loading,
      this.userId = '',
      this.currentWorkoutPlan,
      this.workoutPlans = const {},
      this.history = const [],
      this.plan = const [],
      this.exercises = const {},
      this.currentDay,
      this.currentSplitDay = 0, this.progress = const {}});

  const TrainingsPlanState.loading() : this._();

  const TrainingsPlanState.loaded(
      String userId,
      WorkoutPlan currentWorkoutPlan,
      Map<String, WorkoutPlan> workoutPlans,
      List<HistoryDayEntry> history,
      List<PlanDayEntry> plan,
      Map<String, Exercise> exercises,
      DateTime currentDay,
      int currentSplitDay)
      : this._(
            status: TrainingsPlanStatus.loaded,
            userId: userId,
            currentWorkoutPlan: currentWorkoutPlan,
            workoutPlans: workoutPlans,
            history: history,
            plan: plan,
            exercises: exercises,
            currentDay: currentDay,
            currentSplitDay: currentSplitDay);

  final TrainingsPlanStatus status;
  final String userId;
  final WorkoutPlan? currentWorkoutPlan;
  final Map<String, WorkoutPlan> workoutPlans;
  final List<HistoryDayEntry> history;
  final List<PlanDayEntry> plan;
  final Map<String, Exercise> exercises;
  final DateTime? currentDay;
  final int currentSplitDay;
  final Map<String, Map<int, double>> progress;

  TrainingsPlanState copyWith({
    TrainingsPlanStatus? status,
    String? userId,
    WorkoutPlan? currentWorkoutPlan,
    Map<String, WorkoutPlan>? workoutPlans,
    List<HistoryDayEntry>? history,
    List<PlanDayEntry>? plan,
    Map<String, Exercise>? exercises,
    DateTime? currentDay,
    int? currentSplitDay,
    Map<String, Map<int, double>>? progress,
  }) {
    return TrainingsPlanState._(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      currentWorkoutPlan: currentWorkoutPlan ?? this.currentWorkoutPlan,
      workoutPlans: workoutPlans ?? this.workoutPlans,
      history: history ?? this.history,
      plan: plan ?? this.plan,
      exercises: exercises ?? this.exercises,
      currentDay: currentDay ?? this.currentDay,
      currentSplitDay: currentSplitDay ?? this.currentSplitDay,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props =>
      [status, userId, currentWorkoutPlan, workoutPlans, history, plan, exercises, currentDay, currentSplitDay, progress];
}
