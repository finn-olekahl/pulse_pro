import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

part 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit({required this.userRepository})
      : super(CreateAccountInitial());

  final UserRepository userRepository;

  Future<void> createUserObject(
      {required String name,
      required int birthdate,
      required double weight,
      required int height,
      required String gender}) async {
    emit(CreatingAccount());
    await userRepository.createUserObject(
        name: name,
        birthdate: birthdate,
        weight: weight,
        height: height,
        gender: gender);
    emit(CreateAccountInitial());
  }

  Future<List<List<String>>> generateSplit(
      {required String gender,
      required int height,
      required double weight,
      required int birthdate,
      required String workoutGoal,
      required String workoutIntensity,
      required int maxTimesPerWeek,
      required int timePerDay,
      required List<String> injuries,
      required List<String> muscleFocus,
      required String sportOrientation,
      required String workoutExperience}) async {
    emit(GeneratingSplit());
    final split = await userRepository.generateSplit(
        gender: gender,
        height: height,
        weight: weight,
        birthdate: birthdate,
        workoutGoal: workoutGoal,
        workoutIntensity: workoutIntensity,
        maxTimesPerWeek: maxTimesPerWeek,
        timePerDay: timePerDay,
        injuries: injuries,
        muscleFocus: muscleFocus,
        sportOrientation: sportOrientation,
        workoutExperience: workoutExperience);
    emit(CreateAccountInitial());
    return split;
  }

  Future<WorkoutPlan> generateWorkoutPlan(
      {required List<List<String>> split,
      required String workoutGoal,
      required String gender,
      required int height,
      required double weight,
      required int birthdate,
      required String workoutIntensity,
      required int timePerDay,
      required List<String> injuries,
      required List<String> muscleFocus,
      required String sportOrientation,
      required String workoutExperience}) async {
    emit(GeneratingWorkoutPlan());
    final workoutPlan = await userRepository.generateWorkoutPlan(
        split: split,
        workoutGoal: workoutGoal,
        gender: gender,
        height: height,
        weight: weight,
        birthdate: birthdate,
        workoutIntensity: workoutIntensity,
        timePerDay: timePerDay,
        injuries: injuries,
        muscleFocus: muscleFocus,
        sportOrientation: sportOrientation,
        workoutExperience: workoutExperience);
    emit(CreateAccountInitial());
    return workoutPlan;
  }

  Future<void> updateWorkoutPlans(Map<String, WorkoutPlan> workoutPlans) async {
    emit(AddingWorkoutPlan());
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await userRepository.updateWorkoutPlans(user.uid, workoutPlans);
    }
    emit(CreateAccountInitial());
  }

  Future<void> updateCurrentWorkoutPlan(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await userRepository.updateCurrentWorkoutPlan(user.uid, id);
    }
  }
}
