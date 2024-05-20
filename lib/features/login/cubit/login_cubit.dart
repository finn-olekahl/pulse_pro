import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
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
    emit(state.copyWith(status: LoginStatus.onboarding));

    context.go('/login/onboarding', extra: this);
  }

  void cancelOnboarding(BuildContext context) {
    emit(state.copyWith(status: LoginStatus.preOnboarding));

    context.go('/login', extra: this);
  }

  void continueOnboarding(BuildContext context) {
    emit(state.copyWith(status: LoginStatus.postOnboarding));
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
    required List<Injury> injuries,
    required List<MuscleGroup> muscleFocus,
    required SportOrientation sportOrientation,
  }) {
    emit(state.copyWith(
      status: LoginStatus.postOnboarding,
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

    context.go('/login', extra: this);
  }
}
