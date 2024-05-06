import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/view/login_view.dart';

import '../../../test_helpers.dart';
import 'login_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LoginCubit>()])
void main() {
  group('LoginView', () {
    testPulseProWidget('should display a login screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await mockNetworkImagesFor(() => tester.pumpWidget(MaterialApp(
            home: BlocProvider(
              create: (context) => MockLoginCubit(),
              child: const LoginView(),
            ),
          )));

      expect(find.text('Pulse Pro'), findsOneWidget);
      expect(find.text('Login with Apple'), findsOneWidget);
      expect(find.text('Login with Google'), findsOneWidget);
      expect(find.text('Version beta-1.0'), findsOneWidget);
    });
  });
}
