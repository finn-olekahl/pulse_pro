import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/repositories/exercise_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/day_entry.dart';
import 'package:pulse_pro/shared/models/exercise.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';
import 'package:pulse_pro/shared/models/user_exercise.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

part 'trainings_plan_state.dart';

class TrainingsPlanCubit extends Cubit<TrainingsPlanState> {
  TrainingsPlanCubit(
      {required this.appStateBloc,
      required this.userRepository,
      required this.exerciseRepository})
      : super(const TrainingsPlanState.loading()) {
    _subscription = appStateBloc.stream.listen((state) {
      if (state is! AppStateLoggedIn) return;
      _updateState(state.pulseProUser);
    });

    if (appStateBloc.state is! AppStateLoggedIn) return;
    _updateState((appStateBloc.state as AppStateLoggedIn).pulseProUser);
  }

  final AppStateBloc appStateBloc;
  final UserRepository userRepository;
  final ExerciseRepository exerciseRepository;
  late final StreamSubscription _subscription;

  Future<void> _updateState(PulseProUser pulseProUser) async {
    final String userId = pulseProUser.id;
    final workoutPlans = pulseProUser.workoutPlans;
    final currentWorkoutPlan = workoutPlans[pulseProUser.currentWorkoutPlan];
    final history = pulseProUser.history;

    final Map<String, Exercise> exercises = {};

    print(pulseProUser.workoutPlans);
    print(pulseProUser.currentWorkoutPlan);
    if (currentWorkoutPlan == null) return;
    for (var workoutPlan in workoutPlans.values) {
      for (var splitDay in workoutPlan.days.values) {
        if (splitDay.exercises == null) continue;
        for (var exercise in splitDay.exercises!) {
          if (exercises.containsKey(exercise.id)) continue;
          exercises[exercise.id] = await _loadExercise(exercise.id);
        }
      }
    }

    if (state.status == TrainingsPlanStatus.loading) {
      final now = DateTime.now();
      final cleanNowDate = DateTime(now.year, now.month, now.day);
      final currentSplitDay =
          _calculateCurrentSplitDay(history, currentWorkoutPlan);
      final plan =
          _calculatePlan(currentSplitDay, cleanNowDate, currentWorkoutPlan);

      return emit(TrainingsPlanState.loaded(
        userId,
        currentWorkoutPlan,
        workoutPlans,
        history,
        plan,
        exercises,
        cleanNowDate,
        currentSplitDay,
      ));
    }

    emit(state.copyWith(
        currentWorkoutPlan: currentWorkoutPlan, workoutPlans: workoutPlans, history: history, exercises: exercises));
  }

  Future<Exercise> _loadExercise(String exerciseId) async {
    final exercise = await exerciseRepository.getExercise(exerciseId);
    if (exercise == null) throw Exception('Exercise not found');
    return exercise;
  }

  int _calculateCurrentSplitDay(
      List<HistoryDayEntry> history, WorkoutPlan workoutPlan) {
    if (history.isEmpty) return 0;
    final lastDay = history.last;

    final int lastSplitDay = lastDay.splitDayNumber;
    int currentSplitDay = lastSplitDay + 1;
    if (currentSplitDay >= workoutPlan.days.length) {
      currentSplitDay = 0;
    }

    final now = DateTime.now();

    final cleanLastDate =
        DateTime(lastDay.date.year, lastDay.date.month, lastDay.date.day);
    final cleanNowDate = DateTime(now.year, now.month, now.day);
    int difference = 0;

    while ((cleanNowDate.difference(cleanLastDate).inDays) > difference &&
        workoutPlan.days[currentSplitDay]?.restDay == true) {
      currentSplitDay++;
      difference++;
    }
    return currentSplitDay;
  }

  List<PlanDayEntry> _calculatePlan(
      int currentSplitDay, DateTime now, WorkoutPlan workoutPlan) {
    final List<PlanDayEntry> plan = [];

    int nextSplitDay = currentSplitDay + 1;
    for (int i = 0; i < 14; i++) {
      if (nextSplitDay >= workoutPlan.days.length) {
        nextSplitDay = 0;
      }

      plan.add(PlanDayEntry(
        workoutPlanId: workoutPlan.id,
        date: now.add(Duration(days: i + 1)),
        splitDayNumber: nextSplitDay,
      ));

      nextSplitDay++;
    }
    return plan;
  }

  Future<void> updateCurrentDay(DateTime day) async {
    final cleanDate = DateTime(day.year, day.month, day.day);
    return emit(state.copyWith(currentDay: cleanDate));
  }

  Future<void> updateExerciseWeight(UserExercise exercise, int splitDayKey, int selectedSet, double weight) async {
    if (state.currentWorkoutPlan == null) return;

    final workoutPlan = state.currentWorkoutPlan!;
    final splitDay = workoutPlan.days[splitDayKey];
    if (splitDay == null) return;

    final exercises = splitDay.exercises;
    if (exercises == null) return;
    exercises.removeWhere((element) => element.id == exercise.id);

    final weights = exercise.weights ?? {};
    weights[selectedSet] = weight;
    exercises.add(exercise.copyWith(weights: weights));

    final updatedSplitDay = splitDay.copyWith(exercises: exercises);
    final updatedWorkoutPlan = workoutPlan
        .copyWith(days: {...workoutPlan.days, splitDayKey: updatedSplitDay});
    final updatedWorkoutPlans = state.workoutPlans;
    updatedWorkoutPlans[workoutPlan.id] = updatedWorkoutPlan;

    userRepository.updateWorkoutPlans(state.userId, updatedWorkoutPlans);

    Map<int, double>? progress = state.progress[exercise.id];
    if (progress == null) {
      progress = {selectedSet: weight};
    } else {
      progress[selectedSet] = weight;
    }
    emit(state.copyWith(workoutPlans: updatedWorkoutPlans, progress: {...state.progress, exercise.id: progress}));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
