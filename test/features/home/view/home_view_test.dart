import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pulse_pro/features/home/cubit/home_cubit.dart';
import 'package:pulse_pro/features/home/view/home_view.dart';

import '../../../test_helpers.dart';
import 'home_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HomeCubit>()])
void main() {
  group('HomeView', () {
    testPulseProWidget('test home view appbar', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => MockHomeCubit(),
          child: const HomeView(),
        ),
      ));

      expect(find.text('Fitness App'), findsOneWidget);
    });
  });
}
