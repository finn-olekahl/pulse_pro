import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/view/login_view.dart';

import 'login_view_test.mocks.dart';

@GenerateMocks([LoginCubit, LoginState]) // Erzeugen von Mocks für LoginCubit und LoginState
void main() {
  late MockLoginCubit mockLoginCubit;
  late MockLoginState mockLoginState; // Erstellen eines Mocks für LoginState

  setUp(() {
    mockLoginCubit = MockLoginCubit();
    mockLoginState = MockLoginState();
    when(mockLoginCubit.state).thenReturn(mockLoginState as LoginState); // Verwenden des gemockten Zustands
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

  // Hinzufügen weiterer Testfälle gemäß den Anforderungen
}

class MockLoginState {
}
