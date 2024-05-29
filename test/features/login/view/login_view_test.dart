import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/features/login/view/login_view.dart';
import '../../../fake_authentication_repository.dart';

void main() {
  group('LoginView Tests', () {
    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        home: BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(authenticationRepository: FakeAuthenticationRepository()),
          child: child,
        ),
      );
    }

    testWidgets('should have email and password input fields and a login button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: const LoginView()));
      debugPrint('Widget geladen.');

      expect(find.byType(TextField), findsNWidgets(2));
      debugPrint('Textfelder gefunden.');

      final loginButton = find.byKey(const Key('loginButton'));
      expect(loginButton, findsOneWidget);
      debugPrint('Login-Button gefunden.');

      try {
        await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
        debugPrint('E-Mail eingegeben.');
        await tester.enterText(find.byType(TextField).at(1), 'password');
        debugPrint('Passwort eingegeben.');
        await tester.pump();

        await tester.tap(loginButton);
        debugPrint('Login-Button gedrückt.');
        await tester.pumpAndSettle();

        debugPrint('Login-Button Aktion abgeschlossen.');
      } catch (e) {
        debugPrint('Fehler beim Testen des Login-Buttons: $e');
      }
    });
  });
}
