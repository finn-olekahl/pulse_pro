import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/home/home_page.dart';
import 'package:pulse_pro/features/createAccount/create_account_loading_page.dart';
import 'package:pulse_pro/features/login/login_page.dart';
import 'package:pulse_pro/features/profile/profile_page.dart';
import 'package:pulse_pro/features/splash/view/splash_screen.dart';
import 'package:pulse_pro/features/login/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              GoRoute(
                  path: 'createAccountLoading',
                  builder: (context, state) => const CreateAccountLoadingPage())
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
      redirect: (context, state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final isAccountCreationDataSaved = prefs.getString('name') != null;

        final appState = _appStateBloc.state;
        final matchedLocation = state.matchedLocation;

        final bool isOnSplashScreen = matchedLocation == '/splash';
        final bool isOnLoginPage = matchedLocation == '/login';
        final bool isOnboardingPage = matchedLocation == '/login/onboarding';

        if (appState is AppStateInitial || appState is AppStateLoading) {
          return '/splash';
        }
        if (appState is AppStateLoginInitial && !isOnboardingPage) {
          return '/login';
        }

        if (appState is AppStateNoAccount && isAccountCreationDataSaved) {
          return '/login/createAccountLoading';
        }
        if (appState is AppStateNoAccount && !isAccountCreationDataSaved) {
          return '/login/onboarding';
        }

        if (isOnSplashScreen || isOnLoginPage) return '/';

        return null;
      },
      refreshListenable: _appStateBloc);
}
