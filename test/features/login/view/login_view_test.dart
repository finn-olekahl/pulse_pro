import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/view/login_view.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';

import '../../../test_helpers.dart';
import 'login_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])
void main() {
  group('LoginView', () {
    testPulseProWidget('should display a login screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await mockNetworkImagesFor(() => tester.pumpWidget(MaterialApp(
            home: BlocProvider( 
              create: (context) => LoginCubit(authenticationRepository: MockAuthenticationRepository()),
              child: const LoginView(),
            ),
          )));

     expect(
          find.byWidgetPredicate(
              (widget) => fromRichTextToPlainText(widget) == 'Pulse to the Max,\nPerform like a Pro'),
          findsOneWidget);
      expect(find.text('Login with service'), findsOneWidget);
      expect(find.text('Login with Email'), findsOneWidget);
    });
  });
}
