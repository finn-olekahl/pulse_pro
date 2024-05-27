import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/view/login_view.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';

import 'login_view_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;
  late LoginCubit loginCubit;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    loginCubit = LoginCubit(mockAuthenticationRepository);
  });

  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginCubit>(
          create: (_) => loginCubit,
          child: const LoginView(),
        ),
      ),
    );
  }

  group('LoginView Tests', () {
    testWidgets('Initial state is correct', (WidgetTester tester) async {
      await pumpLoginView(tester);

      // Check if the initial UI is rendered correctly
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Tapping on "Get Started" opens login popup',
        (WidgetTester tester) async {
      await pumpLoginView(tester);

      // Tap on "Get Started" button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Check if the login popup is opened
      expect(find.text('Login or Signup'), findsOneWidget);
    });

    testWidgets('Tapping on "Login" opens login popup',
        (WidgetTester tester) async {
      await pumpLoginView(tester);

      // Tap on "Login" button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Check if the login popup is opened
      expect(find.text('Login or Signup'), findsOneWidget);
    });

    testWidgets('Entering email and password calls signInWithEmailAndPassword',
        (WidgetTester tester) async {
      await pumpLoginView(tester);

      // Open the login popup
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Enter email and password
      await tester.enterText(find.bySemanticsLabel('Email'), 'test@example.com');
      await tester.enterText(find.bySemanticsLabel('Password'), 'password123');

      // Tap on login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify that the signInWithEmailAndPassword method was called
      verify(mockAuthenticationRepository.signInWithEmailAndPassword(
              'test@example.com', 'password123'))
          .called(1);
    });

    testWidgets('Sign in with Google button calls signInWithGoogle',
        (WidgetTester tester) async {
      await pumpLoginView(tester);

      // Open the login popup
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Tap on Google sign-in button
      await tester.tap(find.byIcon(FontAwesomeIcons.google));
      await tester.pumpAndSettle();

      // Verify that the signInWithGoogle method was called
      verify(mockAuthenticationRepository.signInWithGoogle()).called(1);
    });

    testWidgets('Sign in with Apple button calls signInWithApple',
        (WidgetTester tester) async {
      await pumpLoginView(tester);

      // Open the login popup
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Tap on Apple sign-in button
      await tester.tap(find.byIcon(FontAwesomeIcons.apple));
      await tester.pumpAndSettle();

      // Verify that the signInWithApple method was called
      verify(mockAuthenticationRepository.signInWithApple()).called(1);
    });
  });
}
``
