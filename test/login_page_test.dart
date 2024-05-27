import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/login_page.dart';
import 'package:pulse_pro/features/login/view/login_view.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'login_page_test.mocks.dart' as test_mocks;  // Alias für die generierte Mock-Datei

// Mock für AuthenticationRepository generieren
@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])
void main() {
  late test_mocks.MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = test_mocks.MockAuthenticationRepository();
  });

  testWidgets('LoginPage provides LoginCubit and shows LoginView', (WidgetTester tester) async {
    final goRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => LoginCubit(authenticationRepository: mockAuthenticationRepository),
              child: const LoginPage(),
            );
          },
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

    await tester.pumpAndSettle(); // Warten bis alle Animationen und Frames verarbeitet wurden

    // Überprüfen, ob LoginView im Widgetbaum vorhanden ist
    expect(find.byType(LoginView), findsOneWidget);
  });
}
