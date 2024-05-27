import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/repositories/exercise_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';

import 'plan_page_test.mocks.dart';

@GenerateMocks([AppStateBloc, UserRepository, ExerciseRepository])
void main() {
  late MockAppStateBloc mockAppStateBloc;
  late MockUserRepository mockUserRepository;
  late MockExerciseRepository mockExerciseRepository;
  late TrainingsPlanCubit trainingsPlanCubit;

  setUp(() {
    mockAppStateBloc = MockAppStateBloc();
    mockUserRepository = MockUserRepository();
    mockExerciseRepository = MockExerciseRepository();

    when(mockAppStateBloc.state).thenReturn(AppStateInitial());
    when(mockAppStateBloc.stream).thenAnswer((_) => Stream.value(AppStateInitial()));

    trainingsPlanCubit = TrainingsPlanCubit(
      appStateBloc: mockAppStateBloc,
      userRepository: mockUserRepository,
      exerciseRepository: mockExerciseRepository,
    );
  });

  test('initializes correctly', () {
    expect(trainingsPlanCubit.appStateBloc, mockAppStateBloc);
    expect(trainingsPlanCubit.userRepository, mockUserRepository);
    expect(trainingsPlanCubit.exerciseRepository, mockExerciseRepository);
  });

  tearDown(() {
    trainingsPlanCubit.close();
  });
}
