import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authenticationRepository})
      : super(const LoginState.initial());

  final AuthenticationRepository authenticationRepository;

  Future<void> showServiceActionSheet() async {
    HapticFeedback.selectionClick();
    emit(const LoginState.showServiceActionSheet());
    emit(const LoginState.initial());
  }

  Future<void> signInWithApple() async {
    HapticFeedback.mediumImpact();
  }

  Future<void> signInWithGoogle() async {
    HapticFeedback.mediumImpact();
    await authenticationRepository.signInWithGoogle();
  }

  Future<void> signInOrSignUpWithEmailAndPassword(
      {required String email, required String password}) async {
    HapticFeedback.mediumImpact();
    await authenticationRepository.signInOrSignUpWithEmailAndPassword(email, password);
  }
}
