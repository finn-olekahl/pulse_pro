import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';
import 'package:go_router/go_router.dart';
import 'login_cubit_test.mocks.dart' as mocks;

@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])
void main() {
  late LoginCubit loginCubit;
  late mocks.MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = mocks.MockAuthenticationRepository();
    loginCubit = LoginCubit(authenticationRepository: mockAuthenticationRepository);
  });

  group('LoginCubit Tests', () {
    test('Initial state is correct', () {
      expect(loginCubit.state, const LoginState.initial());
      print('Initial state test passed');
    });

    test('signInWithGoogle calls authenticationRepository', () async {
      when(mockAuthenticationRepository.signInWithGoogle())
          .thenAnswer((_) async => null);

      await loginCubit.signInWithGoogle();

      verify(mockAuthenticationRepository.signInWithGoogle()).called(1);
      print('signInWithGoogle test passed');
    });

    test('signInWithEmailAndPassword calls authenticationRepository', () async {
      const email = 'test@example.com';
      const password = 'password';

      when(mockAuthenticationRepository.signInWithEmailAndPassword(email, password))
          .thenAnswer((_) async => null);

      await loginCubit.signInWithEmailAndPassword(email: email, password: password);

      verify(mockAuthenticationRepository.signInWithEmailAndPassword(email, password)).called(1);
      print('signInWithEmailAndPassword test passed');
    });

    test('signUpWithEmailAndPassword calls authenticationRepository', () async {
      const email = 'test@example.com';
      const password = 'password';

      when(mockAuthenticationRepository.signUpWithEmailAndPassword(email, password))
          .thenAnswer((_) async => null);

      await loginCubit.signUpWithEmailAndPassword(email: email, password: password);

      verify(mockAuthenticationRepository.signUpWithEmailAndPassword(email, password)).called(1);
      print('signUpWithEmailAndPassword test passed');
    });

    testWidgets('startOnboarding changes state', (WidgetTester tester) async {
      final GoRouter goRouter = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Container(),
          ),
          GoRoute(
            path: '/login/onboarding',
            builder: (context, state) => Container(),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerDelegate: goRouter.routerDelegate,
          routeInformationParser: goRouter.routeInformationParser,
          routeInformationProvider: goRouter.routeInformationProvider,
        ),
      );

      loginCubit.startOnboarding(tester.element(find.byType(Container)));

      await tester.pumpAndSettle();

      expect(loginCubit.state.status, LoginStatus.onboarding);
      print('startOnboarding test passed');
    });

    testWidgets('cancelOnboarding changes state', (WidgetTester tester) async {
      final GoRouter goRouter = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Container(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => Container(),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerDelegate: goRouter.routerDelegate,
          routeInformationParser: goRouter.routeInformationParser,
          routeInformationProvider: goRouter.routeInformationProvider,
        ),
      );

      loginCubit.cancelOnboarding(tester.element(find.byType(Container)));

      await tester.pumpAndSettle();

      expect(loginCubit.state.status, LoginStatus.preOnboarding);
      print('cancelOnboarding test passed');
    });

    testWidgets('finishOnboarding changes state', (WidgetTester tester) async {
      final GoRouter goRouter = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Container(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => Container(),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerDelegate: goRouter.routerDelegate,
          routeInformationParser: goRouter.routeInformationParser,
          routeInformationProvider: goRouter.routeInformationProvider,
        ),
      );

      final name = 'Test Name';
      final gender = Gender.male;
      final birthDate = DateTime(1990, 1, 1);
      final weight = 70.0;
      final height = 175;
      final workoutGoal = WorkoutGoal.loseWeight;
      final workoutIntensity = WorkoutIntensity.medium;
      final workoutExperience = WorkoutExperience.beginner;
      final maxTimesPerWeek = 3;
      final timePerDay = 60;
      final injuries = <Injury>[];
      final muscleFocus = <MuscleGroup>[];
      final sportOrientation = SportOrientation.none;

      loginCubit.finishOnboarding(
        tester.element(find.byType(Container)),
        name: name,
        gender: gender,
        birthDate: birthDate,
        weight: weight,
        height: height,
        workoutGoal: workoutGoal,
        workoutIntensity: workoutIntensity,
        workoutExperience: workoutExperience,
        maxTimesPerWeek: maxTimesPerWeek,
        timePerDay: timePerDay,
        injuries: injuries,
        muscleFocus: muscleFocus,
        sportOrientation: sportOrientation,
      );

      await tester.pumpAndSettle();

      final state = loginCubit.state;
      expect(state.status, LoginStatus.postOnboarding);
      expect(state.name, 'Test Name');
      expect(state.gender, Gender.male);
      expect(state.birthDate, DateTime(1990, 1, 1));
      expect(state.weight, 70.0);
      expect(state.height, 175);
      expect(state.workoutGoal, WorkoutGoal.loseWeight);
      expect(state.workoutIntensity, WorkoutIntensity.medium);
      expect(state.workoutExperience, WorkoutExperience.beginner);
      expect(state.maxTimesPerWeek, 3);
      expect(state.timePerDay, 60);
      expect(state.injuries, <Injury>[]);
      expect(state.muscleFocus, <MuscleGroup>[]);
      expect(state.sportOrientation, SportOrientation.none);
      print('finishOnboarding test passed');
    });
  });
}
