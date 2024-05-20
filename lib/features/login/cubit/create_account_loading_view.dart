import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountLoadingView extends StatefulWidget {
  const CreateAccountLoadingView({super.key});

  State<CreateAccountLoadingView> createState() =>
      _CreateAccountLoadingViewState();
}

class _CreateAccountLoadingViewState extends State<CreateAccountLoadingView> {
  @override
  void initState() {
    print('entered account loading view');
    startAccountAndWorkoutPlanGeneration();
    super.initState();
  }

  Future<void> startAccountAndWorkoutPlanGeneration() async {
    print("starting account and workout plan creation");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("test_1");

    final gender = prefs.getString('gender');
    final name = prefs.getString('name');
    final workoutGoal = prefs.getString('workoutGoal');
    final workoutIntensity = prefs.getString('workoutIntensity');
    final maxTimesPerWeek = prefs.getInt('maxTimesPerWeek');
    final timePerDay = prefs.getInt('timePerDay');
    final injuries = prefs.getStringList('injuries');
    final muscleFocus = prefs.getStringList('muscleFocus');
    final sportOrientation = prefs.getString('sportOrientation');
    final workoutExperience = prefs.getString('workoutExperience');
    final birthDate = prefs.getInt('birthDate');
    final weight = prefs.getDouble('weight');
    final height = prefs.getInt('height');

    print("test_2");
    print(workoutGoal);
    print(workoutIntensity);
    print(maxTimesPerWeek);
    print(birthDate);
    print(weight);
    print(name);
    print(gender);

    if (birthDate != null &&
        weight != null &&
        height != null &&
        name != null &&
        gender != null) {
      print('creating user object');
      await context.read<AppStateBloc>().userRepository.createUserObject(
          context,
          name: name,
          birthdate: birthDate,
          weight: weight,
          height: height,
          gender: gender);

      print('generating split');
      List<List<String>> split = await context
          .read<AppStateBloc>()
          .userRepository
          .generateSplit(context,
              gender: gender,
              workoutGoal: workoutGoal!,
              workoutIntensity: workoutIntensity!,
              maxTimesPerWeek: maxTimesPerWeek!,
              timePerDay: timePerDay!,
              injuries: injuries!,
              muscleFocus: muscleFocus!,
              sportOrientation: sportOrientation!,
              workoutExperience: workoutExperience!);

      print(split);

      print('generating workout plan');
      WorkoutPlan workoutPlan = await context
          .read<AppStateBloc>()
          .userRepository
          .generateWorkoutPlan(context,
              split: split,
              gender: gender,
              workoutGoal: workoutGoal,
              workoutIntensity: workoutIntensity,
              timePerDay: timePerDay,
              injuries: injuries,
              muscleFocus: muscleFocus,
              sportOrientation: sportOrientation,
              workoutExperience: workoutExperience);

      print(workoutPlan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      body: Stack(
        children: [
          Center(
            child: Lottie.asset('assets/lottie/loading.json',
                width: MediaQuery.sizeOf(context).width / 2,
                height: MediaQuery.sizeOf(context).width / 2),
          )
        ],
      ),
    );
  }
}
