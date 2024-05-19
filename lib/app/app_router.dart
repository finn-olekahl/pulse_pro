import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/home/home_page.dart';
import 'package:pulse_pro/features/login/login_page.dart';
import 'package:pulse_pro/features/profile/profile_page.dart';
import 'package:pulse_pro/features/splash/view/splash_screen.dart';
import 'package:pulse_pro/features/login/onboarding_page.dart';

class AppRouter {
  final BuildContext appContext;

  late final AppStateBloc _appStateBloc;
  GoRouter get router => _goRouter;

  AppRouter(this.appContext) {
    _appStateBloc = appContext.read<AppStateBloc>();
  }

  late final GoRouter _goRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
            routes: [
              GoRoute(
                path: 'onboarding',
                builder: (context, state) => const OnboardingPage(),
              ),
            ]),
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        )
      ],
      redirect: (context, state) {
        final appState = _appStateBloc.state;
        final matchedLocation = state.matchedLocation;

        final bool isOnSplashScreen = matchedLocation == '/splash';
        final bool isOnLoginPage = matchedLocation == '/login' ||
            matchedLocation == '/login/onboarding';

        if (appState is AppStateInitial || appState is AppStateLoading)
          return '/splash';
        if (appState is AppStateLoginInitial ||
            appState is AppStateContinueLogin) return '/login';
        if (appState is AppStateOnboarding) return '/login/onboarding';

        if (isOnSplashScreen || isOnLoginPage) return '/';

        return null;
      },
      refreshListenable: _appStateBloc);
}
