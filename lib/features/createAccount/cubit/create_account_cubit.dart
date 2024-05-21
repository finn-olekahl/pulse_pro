import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

part 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit({required this.userRepository})
      : super(CreateAccountInitial());

  final UserRepository userRepository;

  Future<void> createUserObject(BuildContext context,
      {required String name,
      required int birthdate,
      required double weight,
      required int height,
      required String gender}) async {
    userRepository.createUserObject(context,
        name: name,
        birthdate: birthdate,
        weight: weight,
        height: height,
        gender: gender);
  }

  Future<List<List<String>>> generateSplit(context,
      {required String gender,
      required String workoutGoal,
      required String workoutIntensity,
      required int maxTimesPerWeek,
      required int timePerDay,
      required List<String> injuries,
      required List<String> muscleFocus,
      required String sportOrientation,
      required String workoutExperience}) async {
    final split = userRepository.generateSplit(context,
        gender: gender,
        workoutGoal: workoutGoal,
        workoutIntensity: workoutIntensity,
        maxTimesPerWeek: maxTimesPerWeek,
        timePerDay: timePerDay,
        injuries: injuries,
        muscleFocus: muscleFocus,
        sportOrientation: sportOrientation,
        workoutExperience: workoutExperience);
    return split;
  }

  Future<WorkoutPlan> generateWorkoutPlan(context,
      {required List<List<String>> split,
      required String workoutGoal,
      required String gender,
      required String workoutIntensity,
      required int timePerDay,
      required List<String> injuries,
      required List<String> muscleFocus,
      required String sportOrientation,
      required String workoutExperience}) async {
    final workoutPlan = userRepository.generateWorkoutPlan(context,
        split: split,
        workoutGoal: workoutGoal,
        gender: gender,
        workoutIntensity: workoutIntensity,
        timePerDay: timePerDay,
        injuries: injuries,
        muscleFocus: muscleFocus,
        sportOrientation: sportOrientation,
        workoutExperience: workoutExperience);
    return workoutPlan;
  }

  Future<void> updateWorkoutPlans(Map<String, WorkoutPlan> workoutPlans) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRepository.updateWorkoutPlans(user.uid, workoutPlans);
    }
  }

  Future<void> updateCurrentWorkoutPlan(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRepository.updateCurrentWorkoutPlan(user.uid, id);
    }
  }
}
