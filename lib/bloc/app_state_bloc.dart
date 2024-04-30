import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';

part 'app_state_event.dart';
part 'app_state_state.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppStateState> with ChangeNotifier {
  AppStateBloc({required this.userRepository}) : super(AppStateLoading()) {
    on<_AuthStreamChange>(_onAuthStreamChange);
    on<_LocalUserStreamChange>(_onLocalUserChange);

    _authUserStream = FirebaseAuth.instance.authStateChanges().listen((authUser) => add(_AuthStreamChange(authUser)));
  }

  final UserRepository userRepository;
  late final StreamSubscription<User?> _authUserStream;
  StreamSubscription? _localUserStream;

  Future<void> _startLocalUserStream() async {
    if (_localUserStream != null || state is! AppStateLoading) return;
    final firestore = FirebaseFirestore.instance; 
    _localUserStream = firestore.collection("users").doc((state as AppStateLoading).authUser.uid).snapshots().listen((doc) 
      => add(_LocalUserStreamChange(PulseProUser.fromMap(doc.data() ?? {}))));
  }

  Future<void> _stopLocalUserStream() async {
    if (_localUserStream == null) return;
    _localUserStream!.cancel();
    _localUserStream = null;
  }

  Future<void> _onAuthStreamChange(_AuthStreamChange authStreamChange, Emitter<AppStateState> emit) async {
    final authUser = authStreamChange.authUser;

    if (authUser == null) {
      emit(AppStateInitial());
      notifyListeners();
      _stopLocalUserStream();
      return;
    }

    if (!(await userRepository.userExists(authUser.uid))) {
        emit(AppStateNoAccount(authUser));
      notifyListeners();
    }

    emit(AppStateLoading(authUser));
    notifyListeners();
    _startLocalUserStream();
    return;
  }

  Future<void> _onLocalUserChange(_LocalUserStreamChange localUserStreamChange, Emitter<AppStateState> emit) {
    final localUser = localUserStreamChange.pulseProUser;
    if (localUser == null) return;
    
    if (state is AppStateLoggedIn) {
      emit(AppStateLoggedIn( (state as AppStateLoggedIn).authUser, localUser));
    }

    if (state is AppStateLoading) {
      emit(AppStateLoggedIn( (state as AppStateLoading).authUser, localUser));
    }

    if (state is AppStateNoAccount) {
      emit(AppStateLoggedIn( (state as AppStateNoAccount).authUser, localUser));
    }

    notifyListeners();
  }

  @override
  Future<void> close() {
    _authUserStream.cancel();
    return super.close();
  }
}

