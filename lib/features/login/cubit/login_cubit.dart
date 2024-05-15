import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';

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

  Future<FirebaseAuthException?> signOutWithEmailAndPassword(
      {required String email, required String password}) async {
    HapticFeedback.mediumImpact();
    return await authenticationRepository.signUpWithEmailAndPassword(
        email, password);
  }
}
