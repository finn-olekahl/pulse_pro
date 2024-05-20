import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/view/onboarding_view.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = GoRouterState.of(context).extra as LoginCubit?;
    if (loginCubit == null) return const SizedBox();

    return BlocProvider.value(
      value: loginCubit,
      child: const OnboardingView(),
    );
  }
}
