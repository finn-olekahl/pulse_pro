import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/home/view/widgets/home_content.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/repositories/exercise_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';

import '../../../../test_helpers.dart';
import 'home_content_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppStateBloc>(), MockSpec<UserRepository>(), MockSpec<ExerciseRepository>()])

void main() {
  group('Home content', () {
    testPulseProWidget('test if title is visible', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => TrainingsPlanCubit(appStateBloc: MockAppStateBloc(), userRepository: MockUserRepository(), exerciseRepository: MockExerciseRepository()),
          child: const HomeContent(),
        ),
      ));

      expect(find.byWidgetPredicate((widget) => fromRichTextToPlainText(widget) == 'Todays Workout'), findsOneWidget);
    });

     testPulseProWidget('test if button to start workout is visible', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => TrainingsPlanCubit(appStateBloc: MockAppStateBloc(), userRepository: MockUserRepository(), exerciseRepository: MockExerciseRepository()),
          child: const HomeContent(),
        ),
      ));

      expect(find.text('Start Workout'), findsOneWidget);
    });
  });
}
