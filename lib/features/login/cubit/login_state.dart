part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState._({this.status = LoginStatus.initial});

  const LoginState.initial() : this._();

  final LoginStatus status;

  @override
  List<Object> get props => [];
}

enum LoginStatus { initial }
