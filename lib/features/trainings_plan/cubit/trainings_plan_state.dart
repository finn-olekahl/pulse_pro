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
      this.currentSplitDay = 0});

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

  TrainingsPlanState updateWorkoutPlans(Map<String, WorkoutPlan> workoutPlans) {
    return TrainingsPlanState._(
        status: status,
        userId: userId,
        currentWorkoutPlan: currentWorkoutPlan,
        workoutPlans: workoutPlans,
        history: history,
        plan: plan,
        exercises: exercises,
        currentDay: currentDay,
        currentSplitDay: currentSplitDay);
  }

  TrainingsPlanState datebaseUpdate(WorkoutPlan currentWorkoutPlan, Map<String, WorkoutPlan> workoutPlans,
      List<HistoryDayEntry> history, Map<String, Exercise> exercises) {
    return TrainingsPlanState._(
        status: status,
        userId: userId,
        currentWorkoutPlan: currentWorkoutPlan,
        workoutPlans: workoutPlans,
        history: history,
        plan: plan,
        exercises: exercises,
        currentDay: currentDay,
        currentSplitDay: currentSplitDay);
  }

  TrainingsPlanState updateCurrentDay(DateTime currentDay) {
    return TrainingsPlanState._(
        status: status,
        userId: userId,
        currentWorkoutPlan: currentWorkoutPlan,
        workoutPlans: workoutPlans,
        history: history,
        plan: plan,
        exercises: exercises,
        currentDay: currentDay,
        currentSplitDay: currentSplitDay);
  }

  @override
  List<Object?> get props =>
      [status, userId, currentWorkoutPlan, workoutPlans, history, plan, exercises, currentDay, currentSplitDay];
}
