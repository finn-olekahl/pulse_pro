import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/home/home_page.dart';
import 'package:pulse_pro/features/create_account/create_account_loading_page.dart';
import 'package:pulse_pro/features/licenses/license_page.dart';
import 'package:pulse_pro/features/licenses/view/license_detail_view.dart';
import 'package:pulse_pro/features/login/login_page.dart';
import 'package:pulse_pro/features/profile/profile_page.dart';
import 'package:pulse_pro/features/splash/view/splash_screen.dart';
import 'package:pulse_pro/features/login/onboarding_page.dart';
import 'package:pulse_pro/features/trainings_plan/workout_page.dart';
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
        ),
        GoRoute(
          path: '/workoutPage',
          builder: (context, state) => const WorkoutPage(),
        ),
        GoRoute(
          path: '/workoutPage',
          builder: (context, state) => const WorkoutPage(),
        ),
        GoRoute(
            path: '/licenses',
            builder: (context, state) => const LicensesPage()),
        GoRoute(
            path: '/license',
            builder: (context, state) {
              final title = state.uri.queryParameters['title'];
              final license = state.uri.queryParameters['license'];
              if (title == null || license == null) return const SizedBox();
              return LicenseDetailsView(title: title, license: license);
            })
      ],
      redirect: (context, state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final isAccountCreationDataSaved = prefs.getString('name') != null;
        final isWorkoutRunning = prefs.getString('timestamps') != null;

        final appState = _appStateBloc.state;
        final matchedLocation = state.matchedLocation;

        final bool isOnSplashScreen = matchedLocation == '/splash';
        final bool isOnLoginPage = matchedLocation == '/login';
        final bool isOnboardingPage = matchedLocation == '/login/onboarding';
        final bool isCreateAccountLoadingPage =
            matchedLocation == '/login/createAccountLoading';

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
        if (isWorkoutRunning == true) {
          return '/workoutPage';
        }
        if (isOnSplashScreen || isOnLoginPage || isCreateAccountLoadingPage) {
          return '/';
        }

        return null;
      },
      refreshListenable: _appStateBloc);
}
