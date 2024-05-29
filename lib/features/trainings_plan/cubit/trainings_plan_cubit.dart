import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/repositories/exercise_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/day_entry.dart';
import 'package:pulse_pro/shared/models/exercise.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';
import 'package:pulse_pro/shared/models/user_exercise.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'trainings_plan_state.dart';

class TrainingsPlanCubit extends Cubit<TrainingsPlanState> {
  TrainingsPlanCubit({required this.appStateBloc, required this.userRepository, required this.exerciseRepository})
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
      final currentSplitDay = _calculateCurrentSplitDay(history, currentWorkoutPlan);
      final plan = _calculatePlan(currentSplitDay, cleanNowDate, currentWorkoutPlan);
      final todayDone = history.any((element) => element.date == cleanNowDate);

      final prefs = await SharedPreferences.getInstance();
      Map<String, Map<int, double>>? progressMap;
      Map<String, DateTime>? timestampMap;

      if (prefs.getString('progess') != null && prefs.getString('timestamps') != null) {
        final progress = jsonDecode(prefs.getString('progess')!) as Map<String, dynamic>;
        progressMap = progress.map((key, value) =>
            MapEntry(key, (value as Map).map((key, value) => MapEntry(int.parse(key), value as double))));

        final timestamps = jsonDecode(prefs.getString('timestamps')!) as Map<String, dynamic>;
        timestampMap = timestamps.map((key, value) => MapEntry(key, DateTime.parse(value as String)));
      }

      return emit(TrainingsPlanState.loaded(
        userId,
        currentWorkoutPlan,
        workoutPlans,
        history,
        plan,
        exercises,
        cleanNowDate,
        currentSplitDay,
        todayDone,
        progress: progressMap ?? {},
        timestamps: timestampMap ?? {},
      ));
    }

    emit(state.copyWith(
        currentWorkoutPlan: currentWorkoutPlan, workoutPlans: workoutPlans, history: history, exercises: exercises));
  }

  Future<Exercise> _loadExercise(String exerciseId) async {
    final exercise = await exerciseRepository.getExercise(exerciseId);
    if (exercise == null) throw Exception('Exercise not found: $exerciseId');
    return exercise;
  }

  int _calculateCurrentSplitDay(List<HistoryDayEntry> history, WorkoutPlan workoutPlan) {
    if (history.isEmpty) return 0;
    final lastDay = history.last;

    final now = DateTime.now();
    final cleanNowDate = DateTime(now.year, now.month, now.day);

    if (history.any((element) => element.date == cleanNowDate)) return history.last.splitDayNumber;

    final int lastSplitDay = lastDay.splitDayNumber;
    int currentSplitDay = lastSplitDay + 1;
    if (currentSplitDay >= workoutPlan.days.length) {
      currentSplitDay = 0;
    }

    final cleanLastDate = DateTime(lastDay.date.year, lastDay.date.month, lastDay.date.day);

    int difference = 0;

    while ((cleanNowDate.difference(cleanLastDate).inDays) > difference &&
        workoutPlan.days[currentSplitDay]?.restDay == true) {
      currentSplitDay++;
      difference++;
    }
    return currentSplitDay;
  }

  List<PlanDayEntry> _calculatePlan(int currentSplitDay, DateTime now, WorkoutPlan workoutPlan) {
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

  Future<void> startTraining(BuildContext context) async {
    await _setTimestamp();
    await _setTimestamp(exercise: state.currentWorkoutPlan!.days[state.currentSplitDay]!.exercises!.first);
  }

  Future<void> finishTraining() async {
    await _setTimestamp();

    if (state.currentWorkoutPlan == null) return;
    final splitday = state.currentWorkoutPlan!.days[state.currentSplitDay]!;

    splitday.exercises?.removeWhere((element) => !state.progress.containsKey(element.id));

    final historyEntry = HistoryDayEntry(
        workoutPlanId: state.currentWorkoutPlan!.id,
        splitDayNumber: state.currentSplitDay,
        date: state.currentDay ?? DateTime.now(),
        completedSplitDay: splitday,
        duration: DateTime.now().difference(state.timestamps['start']!));

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await userRepository.addHistoryDayEntry(state.userId, historyEntry);
    return emit(state.copyWith(history: [...state.history, historyEntry], todayDone: true));
  }

  Future<void> _setTimestamp({UserExercise? exercise}) async {
    if (exercise == null) {
      if (state.timestamps.containsKey('start')) {
        emit(state.copyWith(timestamps: {...state.timestamps, 'end': DateTime.now()}));
        _saveProgressLocally();
        return;
      }

      emit(state.copyWith(timestamps: {...state.timestamps, 'start': DateTime.now()}));
      _saveProgressLocally();
      return;
    }

    emit(state.copyWith(timestamps: {...state.timestamps, exercise.id: DateTime.now()}));
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
    final updatedWorkoutPlan = workoutPlan.copyWith(days: {...workoutPlan.days, splitDayKey: updatedSplitDay});
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
    await _saveProgressLocally();

    if (exercise.sets >= selectedSet) await nextExercise(exercise);
  }

  Future<void> nextExercise(UserExercise userExercise) async {
    if (state.currentWorkoutPlan == null) return;
    final remainingExercises = state.currentWorkoutPlan!.days[state.currentSplitDay]?.exercises ?? [];
    remainingExercises.remove(userExercise);

    if (remainingExercises.isEmpty) {
      await finishTraining();
      return;
    }

    await _setTimestamp(exercise: remainingExercises.first);
  }

  Future<void> _saveProgressLocally() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('progess',
        jsonEncode(state.progress.map((key, value) => MapEntry(key, value.map((k, v) => MapEntry(k.toString(), v))))));
    await prefs.setString('timestamps',
        jsonEncode(state.timestamps.map((key, value) => MapEntry(key, value.toIso8601String()))));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
