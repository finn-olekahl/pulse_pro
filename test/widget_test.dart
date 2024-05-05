// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/main.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

    await Firebase.initializeApp();
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => AuthenticationRepository(),
      ),
      RepositoryProvider(
        create: (context) => UserRepository(),
      ),
    ],
    child: BlocProvider(
      lazy: false,
      create: (context) => AppStateBloc(
        userRepository: context.read<UserRepository>()),
      child: const PulseProApp(),
    ),
  ));

    // Verify that our counter starts at 0.
    expect(find.text('Pulse Pro'), findsOneWidget);

  });
}
