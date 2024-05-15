import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pulse_pro/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:pulse_pro/features/onboarding/view/onboarding_view.dart';

import '../test_helpers.dart';
import 'onboarding_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OnboardingCubit>()])

void main(){

  group('OnboardingView', () { 
    testPulseProWidget('test onboarding view header', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create:(context) => MockOnboardingCubit(),
          child: const OnboardingView(),
        ),
      ));

      expect(find.text('Geschlecht'), findsOneWidget);
    });
  });
}