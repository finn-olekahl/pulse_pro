import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])
import 'login_cubit_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginCubit', () {
    late LoginCubit loginCubit;
    late MockAuthenticationRepository mockAuthenticationRepository;

    setUp(() {
      mockAuthenticationRepository = MockAuthenticationRepository();
      loginCubit = LoginCubit(authenticationRepository: mockAuthenticationRepository);
    });

    tearDown(() {
      loginCubit.close();
    });

    test('initial state is LoginInitial', () {
      print('Testing initial state...');
      expect(loginCubit.state, equals(const LoginState.initial()));
      print('Initial state test passed');
    });

    test('signInWithGoogle emits success state on success', () async {
      print('Testing signInWithGoogle...');
      when(mockAuthenticationRepository.signInWithGoogle())
          .thenAnswer((_) async => null);

      await loginCubit.signInWithGoogle();

      verify(mockAuthenticationRepository.signInWithGoogle()).called(1);
      print('signInWithGoogle test passed');
    });

    test('signInWithEmailAndPassword emits success state on success', () async {
      const email = 'test@example.com';
      const password = 'password';
      print('Testing signInWithEmailAndPassword...');

      when(mockAuthenticationRepository.signInWithEmailAndPassword(email, password))
          .thenAnswer((_) async => null);

      await loginCubit.signInWithEmailAndPassword(email: email, password: password);

      verify(mockAuthenticationRepository.signInWithEmailAndPassword(email, password)).called(1);
      print('signInWithEmailAndPassword test passed');
    });

    test('signOutWithEmailAndPassword emits success state on success', () async {
      const email = 'test@example.com';
      const password = 'password';
      print('Testing signOutWithEmailAndPassword...');

      when(mockAuthenticationRepository.signUpWithEmailAndPassword(email, password))
          .thenAnswer((_) async => null);

      await loginCubit.signOutWithEmailAndPassword(email: email, password: password);

      verify(mockAuthenticationRepository.signUpWithEmailAndPassword(email, password)).called(1);
      print('signOutWithEmailAndPassword test passed');
    });
  });
}
