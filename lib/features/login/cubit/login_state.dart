part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState._({this.status = LoginStatus.initial});

  const LoginState.initial() : this._();

  const LoginState.showServiceActionSheet() : this._(status: LoginStatus.showServiceActionSheet);

  final LoginStatus status;

  @override
  List<Object> get props => [];
}

enum LoginStatus { initial, showServiceActionSheet }
