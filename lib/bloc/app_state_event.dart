part of 'app_state_bloc.dart';

sealed class AppStateEvent extends Equatable {
  const AppStateEvent();

  @override
  List<Object> get props => [];
}

class _AuthStreamChange extends AppStateEvent {
  const _AuthStreamChange(this.authUser);

  final User? authUser;
}

class _LocalUserStreamChange extends AppStateEvent {
  const _LocalUserStreamChange(this.pulseProUser);

  final PulseProUser? pulseProUser;
}

class LocalUserLookUp extends AppStateEvent {
  const LocalUserLookUp();
}