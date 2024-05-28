import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.appStateBloc, required this.authenticationRepository, required this.userRepository})
      : super(const ProfileState.initial()) {
    _appStateStream = appStateBloc.stream.listen((state) {
      if (state is! AppStateLoggedIn) return;
      emit(this.state.copyWith(pulseProUser: state.pulseProUser));
    });

    if (appStateBloc.state is AppStateLoggedIn) {
      emit(ProfileState.loaded((appStateBloc.state as AppStateLoggedIn).pulseProUser));
    }
  }

  final AppStateBloc appStateBloc;
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  late final StreamSubscription _appStateStream;

  Future<void> edit() async {
    if (state.status == ProfileStatus.initial) return;
    HapticFeedback.mediumImpact();
    emit(state.copyWith(status: state.status == ProfileStatus.edit ? ProfileStatus.loaded : ProfileStatus.edit));
  }

  Future<void> editValue(ProfileStatus status) async {
    if (state.status == status) return;
    HapticFeedback.mediumImpact();
    emit(state.copyWith(status: status));
  }

  Future<void> updateValue(String key, dynamic value) async {
    if (state.pulseProUser == null) return;
    await userRepository.updateValue(state.pulseProUser!.id, key, value);
  }

  Future<void> logout() async {
    HapticFeedback.heavyImpact();
    await authenticationRepository.signOut();
  }

  @override
  Future<void> close() {
    _appStateStream.cancel();
    return super.close();
  }
}
