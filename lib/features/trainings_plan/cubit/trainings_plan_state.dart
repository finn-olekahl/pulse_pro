part of 'trainings_plan_cubit.dart';

enum TraingingsPlanStatus { loading, loaded }

class TrainingsPlanState extends Equatable {
  const TrainingsPlanState._(
      {this.status = TraingingsPlanStatus.loading,
      this.userId = '',
      this.currentWorkoutPlan,
      this.workoutPlans = const {},
      this.history = const [],
      this.plan = const [],
      this.exercises = const {}});

  const TrainingsPlanState.loading() : this._();

  const TrainingsPlanState.loaded(String userId, WorkoutPlan currentWorkoutPlan, Map<String, WorkoutPlan> workoutPlans,
      List<HistoryDayEntry> history, List<PlanDayEntry> plan, Map<String, Exercise> exercises)
      : this._(
            status: TraingingsPlanStatus.loaded,
            userId: userId,
            currentWorkoutPlan: currentWorkoutPlan,
            workoutPlans: workoutPlans,
            history: history,
            plan: plan,
            exercises: exercises);

  final TraingingsPlanStatus status;
  final String userId;
  final WorkoutPlan? currentWorkoutPlan;
  final Map<String, WorkoutPlan> workoutPlans;
  final List<HistoryDayEntry> history;
  final List<PlanDayEntry> plan;
  final Map<String, Exercise> exercises;

  TrainingsPlanState updateWorkoutPlans(Map<String, WorkoutPlan> workoutPlans) {
    return TrainingsPlanState._(
      status: status,
      userId: userId,
      currentWorkoutPlan: currentWorkoutPlan,
      workoutPlans: workoutPlans,
      history: history,
      plan: plan,
      exercises: exercises
    );
  }

  @override
  List<Object?> get props => [status, userId, currentWorkoutPlan, workoutPlans, history, plan];
}
