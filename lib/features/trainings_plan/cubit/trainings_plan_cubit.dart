import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/day_entry.dart';
import 'package:pulse_pro/shared/models/exercise.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

part 'trainings_plan_state.dart';

class TrainingsPlanCubit extends Cubit<TrainingsPlanState> {
  TrainingsPlanCubit({required this.appStateBloc, required this.userRepository})
      : super(const TrainingsPlanState.loading()) {
    _subscription = appStateBloc.stream.listen((state) {
      if (state is! AppStateLoggedIn) return;
    });

    final String userId = (appStateBloc.state as AppStateLoggedIn).pulseProUser.id;
    final workoutPlans = (appStateBloc.state as AppStateLoggedIn).pulseProUser.workoutPlans;
    final currentWorkoutPlan = workoutPlans[(appStateBloc.state as AppStateLoggedIn).pulseProUser.currentWorkoutPlan];
    final history = (appStateBloc.state as AppStateLoggedIn).pulseProUser.history;
    final plan = (appStateBloc.state as AppStateLoggedIn).pulseProUser.plan;

    if (currentWorkoutPlan == null) return;
    emit(TrainingsPlanState.loaded(userId, currentWorkoutPlan, workoutPlans, history, plan));
  }

  final AppStateBloc appStateBloc;
  final UserRepository userRepository;
  late final StreamSubscription _subscription;

  Future<void> updateExerciseWeight(Exercise exercise, int splitDayKey, int rep, int weight) async {
    if (state.currentWorkoutPlan == null) return;

    final workoutPlan = state.currentWorkoutPlan!;
    final splitDay = workoutPlan.days[splitDayKey];
    if (splitDay == null) return;

    final exercises = splitDay.exercises;
    if (exercises == null) return;
    exercises.removeWhere((element) => element.id == exercise.id);

    final weights = exercise.weights ?? {};
    weights[rep] = weight;
    exercises.add(exercise.copyWith(weights: weights));

    final updatedSplitDay = splitDay.copyWith(exercises: exercises);
    final updatedWorkoutPlan = workoutPlan.copyWith(days: {...workoutPlan.days, splitDayKey: updatedSplitDay});
    final updatedWorkoutPlans = state.workoutPlans;
    updatedWorkoutPlans[workoutPlan.id] = updatedWorkoutPlan;

    userRepository.updateWorkoutPlans(state.userId, updatedWorkoutPlans);

    emit(state.updateWorkoutPlans(updatedWorkoutPlans));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
