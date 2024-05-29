import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';

import 'login_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])
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

    test('cancelOnboarding() is updating status', () {
      loginCubit.cancelOnboarding(null);

      expect(loginCubit.state.status, LoginStatus.preOnboarding);
    });

    test('continueOnboarding() is updating status', () {
      loginCubit.continueOnboarding();

      expect(loginCubit.state.status, LoginStatus.postOnboarding);
    });

    tearDown(() {
      loginCubit.close();
    });
  });
}
