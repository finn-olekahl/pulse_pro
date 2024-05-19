import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';
import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authenticationRepository})
      : super(const LoginState.initial());

  final AuthenticationRepository authenticationRepository;

  Future<FirebaseAuthException?> signInWithApple() async {
    HapticFeedback.mediumImpact();
    return null;
  }

  Future<FirebaseAuthException?> signInWithGoogle() async {
    HapticFeedback.mediumImpact();
    return await authenticationRepository.signInWithGoogle();
  }

  Future<FirebaseAuthException?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    HapticFeedback.mediumImpact();
    return await authenticationRepository.signInWithEmailAndPassword(
        email, password);
  }

  Future<FirebaseAuthException?> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    HapticFeedback.mediumImpact();
    return await authenticationRepository.signUpWithEmailAndPassword(
        email, password);
  }

  Future<FirebaseAuthException?> signOutWithEmailAndPassword(
      {required String email, required String password}) async {
    HapticFeedback.mediumImpact();
    return await authenticationRepository.signUpWithEmailAndPassword(
        email, password);
  }

  void startOnboarding(BuildContext context) {
    context.read<AppStateBloc>().add(const StartOnboarding());
  }

  void cancelOnboarding(BuildContext context) {
    context.read<AppStateBloc>().add(const CancelOnboarding());
  }

  void continueOnboarding(BuildContext context) {
    context.read<AppStateBloc>().add(const FinishOnboarding());
  }

  void finishOnboarding(
    BuildContext context, {
    required String name,
    required Gender gender,
    required DateTime birthDate,
    required double weight,
    required int height,
    required WorkoutGoal workoutGoal,
    required WorkoutIntensity workoutIntensity,
    required WorkoutExperience workoutExperience,
    required int maxTimesPerWeek,
    required int timePerDay,
    required List<Injuries> injuries,
    required List<MuscleGroup> muscleFocus,
    required SportOrientation sportOrientation,
  }) {
    emit(state.copyWith(
      name: name,
      gender: gender,
      birthDate: birthDate,
      weight: weight,
      height: height,
      workoutGoal: workoutGoal,
      workoutIntensity: workoutIntensity,
      workoutExperience: workoutExperience,
      maxTimesPerWeek: maxTimesPerWeek,
      timePerDay: timePerDay,
      injuries: injuries,
      muscleFocus: muscleFocus,
      sportOrientation: sportOrientation,
    ));

    context.read<AppStateBloc>().add(const FinishOnboarding());
  }
}
