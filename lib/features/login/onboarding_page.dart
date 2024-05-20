import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/view/onboarding_view.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = GoRouterState.of(context).extra as LoginCubit?;
    if (loginCubit == null) {
      return BlocProvider(
        create: (context) =>
            LoginCubit(authenticationRepository: AuthenticationRepository()),
        child: const OnboardingView(
          continueSignup: false,
        ),
      );
    }

    return BlocProvider.value(
      value: loginCubit,
      child: const OnboardingView(),
    );
  }
}
