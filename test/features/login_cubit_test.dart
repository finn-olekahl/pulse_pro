import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';



class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  group('LoginCubit Initialization Tests', () {
    late LoginCubit loginCubit;
    late MockAuthenticationRepository mockAuthRepo;

    setUp(() {
      mockAuthRepo = MockAuthenticationRepository();
      loginCubit = LoginCubit(authenticationRepository: mockAuthRepo);
    });

    test('initial state is LoginState.initial()', () {
      expect(loginCubit.state, const LoginState.initial());
    });

    tearDown(() {
      loginCubit.close();
    });
  });
}
