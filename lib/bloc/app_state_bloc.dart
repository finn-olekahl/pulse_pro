import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';

part 'app_state_event.dart';
part 'app_state_state.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppStateState>
    with ChangeNotifier {
  AppStateBloc({required this.userRepository}) : super(AppStateInitial()) {
    on<_AuthStreamChange>(_onAuthStreamChange);
    on<_LocalUserStreamChange>(_onLocalUserChange);
    on<LocalUserLookUp>(_onLocalUserLookUp);
    on<StartOnboarding>(_onStartOnboarding);
    on<FinishOnboarding>(_onFinishOnboarding);

    _authUserStream = FirebaseAuth.instance
        .authStateChanges()
        .listen((authUser) => add(_AuthStreamChange(authUser)));
  }

  final UserRepository userRepository;
  late final StreamSubscription<User?> _authUserStream;
  StreamSubscription? _localUserStream;

  Future<void> _startLocalUserStream() async {
    if (_localUserStream != null || state is! AppStateLoading) return;
    final firestore = FirebaseFirestore.instance;
    _localUserStream = firestore
        .collection('user')
        .doc((state as AppStateLoading).authUser.uid)
        .snapshots()
        .listen((doc) => add(
            _LocalUserStreamChange(PulseProUser.fromJson(doc.data() ?? {}))));
  }

  Future<void> _stopLocalUserStream() async {
    if (_localUserStream == null) return;
    _localUserStream!.cancel();
    _localUserStream = null;
  }

  Future<void> _onStartOnboarding(
      StartOnboarding startOnboarding, Emitter<AppStateState> emit) async {
    emit(AppStateOnboarding());
  }

  Future<void> _onFinishOnboarding(
      FinishOnboarding finishOnboarding, Emitter<AppStateState> emit) async {
    emit(AppStateContinueLogin());
  }

  Future<void> _onAuthStreamChange(
      _AuthStreamChange authStreamChange, Emitter<AppStateState> emit) async {
    final authUser = authStreamChange.authUser;

    if (authUser == null) {
      emit(AppStateLoginInitial());
      notifyListeners();
      _stopLocalUserStream();
      return;
    }

    if (!(await userRepository.userExists(authUser.uid))) {
      emit(AppStateNoAccount(authUser));
      notifyListeners();
      return;
    }

    emit(AppStateLoading(authUser));
    notifyListeners();
    _startLocalUserStream();
    return;
  }

  Future<void> _onLocalUserChange(_LocalUserStreamChange localUserStreamChange,
      Emitter<AppStateState> emit) async {
    final localUser = localUserStreamChange.pulseProUser;
    if (localUser == null) return;

    if (state is AppStateLoggedIn) {
      emit(AppStateLoggedIn((state as AppStateLoggedIn).authUser, localUser));
    }

    if (state is AppStateLoading) {
      emit(AppStateLoggedIn((state as AppStateLoading).authUser, localUser));
    }

    if (state is AppStateNoAccount) {
      emit(AppStateLoggedIn((state as AppStateNoAccount).authUser, localUser));
    }

    notifyListeners();
  }

  Future<void> _onLocalUserLookUp(
      LocalUserLookUp localUserLookUp, Emitter<AppStateState> emit) async {
    User? authUser;

    if (state is AppStateNoAccount) {
      authUser = (state as AppStateNoAccount).authUser;
    }
    if (authUser == null) return;

    if (!(await userRepository.userExists(authUser.uid))) {
      emit(AppStateNoAccount(authUser));
      notifyListeners();
    }

    emit(AppStateLoading(authUser));
    notifyListeners();
    _startLocalUserStream();
  }

  @override
  Future<void> close() {
    _authUserStream.cancel();
    return super.close();
  }
}
