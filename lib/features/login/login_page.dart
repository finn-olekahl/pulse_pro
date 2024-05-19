import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/view/login_view.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GoRouterState.of(context).extra as LoginCubit? ?? LoginCubit(authenticationRepository: AuthenticationRepository()),
      child: const LoginView(),
    );
  }
}
