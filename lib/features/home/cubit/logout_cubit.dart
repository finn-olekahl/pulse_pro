import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'logout_state.dart';

class LogOutCubit extends Cubit<LogoutState> {
  LogOutCubit({required this.authenticationRepository}) : super(LogoutInitial());

  final AuthenticationRepository authenticationRepository;

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

}