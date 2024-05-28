part of 'profile_cubit.dart';

enum ProfileStatus { initial, loaded, edit, editBirthDate, editGender, editHeight, editWeight }

class ProfileState extends Equatable {
  const ProfileState._({this.status = ProfileStatus.initial, this.pulseProUser});

  const ProfileState.initial() : this._();

  const ProfileState.loaded(PulseProUser pulseProUser) : this._(status: ProfileStatus.loaded, pulseProUser: pulseProUser);

  final ProfileStatus status;
  final PulseProUser? pulseProUser;

  ProfileState copyWith({ProfileStatus? status, PulseProUser? pulseProUser}) {
    return ProfileState._(
      status: status ?? this.status,
      pulseProUser: pulseProUser ?? this.pulseProUser,
    );
  }

  @override
  List<Object?> get props => [status, pulseProUser];
}
