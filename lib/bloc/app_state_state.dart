part of 'app_state_bloc.dart';

sealed class AppStateState extends Equatable {
  const AppStateState();

  @override
  List<Object> get props => [];
}

final class AppStateInitial extends AppStateState {}

final class AppStateLoginInitial extends AppStateState {}

final class AppStateLoading extends AppStateState {
  const AppStateLoading(this.authUser);

  final User authUser;

  @override
  List<Object> get props => [authUser];
}

final class AppStateNoAccount extends AppStateState {
  const AppStateNoAccount(this.authUser);

  final User authUser;

  @override
  List<Object> get props => [authUser];
}

final class AppStateLoggedIn extends AppStateState {
  const AppStateLoggedIn(this.authUser, this.pulseProUser);

  final User authUser;
  final PulseProUser pulseProUser;

  @override
  List<Object> get props => [authUser, pulseProUser];
}

