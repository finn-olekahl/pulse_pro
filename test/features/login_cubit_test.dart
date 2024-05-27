import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/login/view/onboarding_view.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

import 'onboarding_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LoginCubit>(), MockSpec<AuthenticationRepository>()])
void main() {
  late MockLoginCubit mockLoginCubit;

  setUp(() {
    mockLoginCubit = MockLoginCubit();
  });

  Future<void> pumpOnboardingView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: const OnboardingView(),
        ),
      ),
    );
  }

  testWidgets('Initial Page is displayed', (WidgetTester tester) async {
    await pumpOnboardingView(tester);

    expect(find.text("Let's Get to Know Each Other."), findsOneWidget);
  });

  testWidgets('Name input is functional', (WidgetTester tester) async {
    await pumpOnboardingView(tester);

    await tester.enterText(find.byType(TextField), 'Test Name');
    expect(find.text('Test Name'), findsOneWidget);
  });

  testWidgets('Next button navigates to gender selection', (WidgetTester tester) async {
    await pumpOnboardingView(tester);

    await tester.enterText(find.byType(TextField), 'Test Name');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text("What's your gender?"), findsOneWidget);
  });

  testWidgets('Finish button calls finishOnboarding', (WidgetTester tester) async {
    await pumpOnboardingView(tester);

    // Simuliere das Ausfüllen aller Seiten bis zur letzten Seite
    await tester.enterText(find.byType(TextField), 'Test Name');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Navigiere durch die weiteren Seiten, z.B. Gender, Fitness Goals, etc.
    // Beispielwerte für die Argumente von finishOnboarding
    const String name = 'Test Name';
    const Gender gender = Gender.male;
    final DateTime birthDate = DateTime(1990, 1, 1); // DateTime kann nicht const sein
    const double weight = 70.0;
    const int height = 175;
    const WorkoutGoal workoutGoal = WorkoutGoal.loseWeight;
    const WorkoutIntensity workoutIntensity = WorkoutIntensity.medium;
    const WorkoutExperience workoutExperience = WorkoutExperience.beginner;
    const int maxTimesPerWeek = 3;
    const int timePerDay = 60;
    final List<Injury> injuries = []; // Listen können nicht const sein
    final List<MuscleGroup> muscleFocus = []; // Listen können nicht const sein
    const SportOrientation sportOrientation = SportOrientation.none;

    when(mockLoginCubit.finishOnboarding(
      any,
      name: anyNamed('name'),
      gender: anyNamed('gender'),
      birthDate: anyNamed('birthDate'),
      weight: anyNamed('weight'),
      height: anyNamed('height'),
      workoutGoal: anyNamed('workoutGoal'),
      workoutIntensity: anyNamed('workoutIntensity'),
      workoutExperience: anyNamed('workoutExperience'),
      maxTimesPerWeek: anyNamed('maxTimesPerWeek'),
      timePerDay: anyNamed('timePerDay'),
      injuries: anyNamed('injuries'),
      muscleFocus: anyNamed('muscleFocus'),
      sportOrientation: anyNamed('sportOrientation'),
    )).thenAnswer((_) async => {});

    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    verify(mockLoginCubit.finishOnboarding(
      any,
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
    )).called(1);
  });
}
