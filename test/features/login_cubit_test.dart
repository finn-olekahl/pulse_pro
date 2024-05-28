import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

@GenerateNiceMocks([MockSpec<LoginCubit>()])
void main() {
  group('LoginCubit Tests', () {
    late LoginCubit loginCubit;
    late MockAuthenticationRepository mockAuthenticationRepository;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockAuthenticationRepository = MockAuthenticationRepository();
      mockSharedPreferences = MockSharedPreferences();
      SharedPreferences.setMockInitialValues({});
      loginCubit = LoginCubit(authenticationRepository: mockAuthenticationRepository);
    });

    tearDown(() {
      loginCubit.close();
    });

    test('Successful signInWithEmailAndPassword should emit loggedIn state', () async {
      // Verwendung von 'any' um sicherzustellen, dass die Parameter nicht null sind
      when(mockAuthenticationRepository.signInWithEmailAndPassword('email','password'))
          .thenAnswer((_) async {
            await Future.delayed(Duration(seconds: 2));
            return Future.value(null); 
          });
      when(mockSharedPreferences.getString('name')).thenReturn('Test User');

      expectLater(
        loginCubit.stream,
        emitsInOrder([
          equals(const LoginState.initial()),
          predicate<LoginState>((state) => state.status == LoginStatus.loggedIn),
        ]),
      );

      await loginCubit.signInWithEmailAndPassword(email: 'test@example.com', password: 'test123');
    });

    test('Failed signInWithEmailAndPassword should emit initial state', () async {
      when(mockAuthenticationRepository.signInWithEmailAndPassword('email','password'))
          .thenAnswer((_) async {
            return Future.value(null);
          });
      when(mockSharedPreferences.getString('name')).thenReturn(null);

      expectLater(
        loginCubit.stream,
        emitsInOrder([
          equals(const LoginState.initial()),
          predicate<LoginState>((state) => state.status == LoginStatus.initial),
        ]),
      );

      await loginCubit.signInWithEmailAndPassword(email: 'fail@example.com', password: 'fail123');
    });
  });
}
