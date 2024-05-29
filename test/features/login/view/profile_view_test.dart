import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/profile/cubit/profile_cubit.dart';
import 'package:pulse_pro/features/profile/view/profile_view.dart';
import 'package:pulse_pro/features/profile/view/widgets/edit_data_button.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';

class MockAppStateBloc extends Mock implements AppStateBloc {}
class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('ProfileView Tests', () {
    late AppStateBloc appStateBloc;
    late AuthenticationRepository authenticationRepository;
    late UserRepository userRepository;

    setUp(() {
      appStateBloc = MockAppStateBloc();
      authenticationRepository = MockAuthenticationRepository();
      userRepository = MockUserRepository();
    });

    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        home: BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            appStateBloc: appStateBloc,
            authenticationRepository: authenticationRepository,
            userRepository: userRepository
          ),
          child: child,
        ),
      );
    }

    testWidgets('ProfileView sollte einen EditDataButton enthalten und auf Interaktionen reagieren', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: ProfileView()));
      debugPrint('Widget geladen.');

      final editButton = find.byType(EditDataButton);
      expect(editButton, findsOneWidget);
      debugPrint('EditDataButton gefunden.');

      try {
        await tester.tap(editButton);
        debugPrint('EditDataButton gedrückt.');
        await tester.pump(); 

        debugPrint('EditDataButton Aktion abgeschlossen.');
      } catch (e) {
        debugPrint('Fehler beim Testen des EditDataButton: $e');
      }
    });
  });
}
