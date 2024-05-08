import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../test_helpers.dart';

@GenerateNiceMocks([MockSpec<OnboardingCubit>()])


void main(){

  group('OnboardingView', () { 
    testPulseProWidget('test onboarding view header', (tester) {
      tester.pumpWidget(MaterialApp(
        home: const OnboardingView(),
      ));
    });
  });
}