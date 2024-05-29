import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/view/login_view.dart';

import 'login_view_test.mocks.dart';

class FakeLoginState extends Fake {}

@GenerateNiceMocks([MockSpec<LoginCubit>()])
void main() {
  late MockLoginCubit mockLoginCubit;

  setUp(() {
    mockLoginCubit = MockLoginCubit();
    when(mockLoginCubit.state).thenReturn(FakeLoginState() as LoginState);
  });

  Future<void> pumpLoginView(WidgetTester tester) async {
    final GoRouter goRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider<LoginCubit>.value(
            value: mockLoginCubit,
            child: const LoginView(),
          ),
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
  }

  testWidgets('Initial Page displays correctly', (WidgetTester tester) async {
    await pumpLoginView(tester);
    await tester.pumpAndSettle();

    expect(find.text('Pulse up,'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Get Started button navigates to onboarding', (WidgetTester tester) async {
    await pumpLoginView(tester);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    verify(mockLoginCubit.startOnboarding(any)).called(1);
  });

  testWidgets('Login button opens login popup', (WidgetTester tester) async {
    await pumpLoginView(tester);

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Login with email and password', (WidgetTester tester) async {
    await pumpLoginView(tester);

    await tester.tap(find.text('Login'));
    await tester.pump();

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    verify(mockLoginCubit.signInWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password',
    )).called(1);
  });

  testWidgets('Signup with email and password', (WidgetTester tester) async {
    when(mockLoginCubit.state).thenReturn(LoginState.postOnboarding());

    await pumpLoginView(tester);
    await tester.pump();

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.enterText(find.byType(TextField).at(2), 'password');
    await tester.tap(find.text('Signup'));
    await tester.pumpAndSettle();

    verify(mockLoginCubit.signUpWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password',
    )).called(1);
  });

  testWidgets('Login with Google', (WidgetTester tester) async {
    await pumpLoginView(tester);

    await tester.tap(find.text('Login'));
    await tester.pump();

    await tester.tap(find.byIcon(FontAwesomeIcons.google));
    await tester.pumpAndSettle();

    verify(mockLoginCubit.signInWithGoogle()).called(1);
  });

  testWidgets('Login with Apple', (WidgetTester tester) async {
    await pumpLoginView(tester);

    await tester.tap(find.text('Login'));
    await tester.pump();

    await tester.tap(find.byIcon(FontAwesomeIcons.apple));
    await tester.pumpAndSettle();

    verify(mockLoginCubit.signInWithApple()).called(1);
  });

  testWidgets('Toggle between Login and Signup', (WidgetTester tester) async {
    when(mockLoginCubit.state).thenReturn(LoginState.postOnboarding());

    await pumpLoginView(tester);
    await tester.pump();

    await tester.tap(find.text('Login instead'));
    await tester.pump();

    verify(mockLoginCubit.cancelOnboarding(any)).called(1);

    await tester.tap(find.text('Signup instead'));
    await tester.pump();

    verify(mockLoginCubit.continueOnboarding(any)).called(1);
  });
}