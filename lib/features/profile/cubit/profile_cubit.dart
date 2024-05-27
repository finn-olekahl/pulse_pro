import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.appStateBloc, required this.authenticationRepository})
      : super(const ProfileState.initial()) {
    _appStateStream = appStateBloc.stream.listen((state) {
      if (state is! AppStateLoggedIn) return;
      emit(ProfileState.loggedIn(state.pulseProUser));
    });

    if (appStateBloc.state is AppStateLoggedIn) {
      emit(ProfileState.loggedIn((appStateBloc.state as AppStateLoggedIn).pulseProUser));
    }
  }

  final AppStateBloc appStateBloc;
  final AuthenticationRepository authenticationRepository;
  late final StreamSubscription _appStateStream;

  Future<void> logout() async {
    HapticFeedback.mediumImpact();
    await authenticationRepository.signOut();
  }

  @override
  Future<void> close() {
    _appStateStream.cancel();
    return super.close();
  }
}
