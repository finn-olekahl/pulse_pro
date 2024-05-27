part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState._({this.pulseProUser});

  const ProfileState.initial() : this._();

  const ProfileState.loggedIn(PulseProUser pulseProUser) : this._(pulseProUser: pulseProUser);

  final PulseProUser? pulseProUser;

  @override
  List<Object?> get props => [pulseProUser];
}
