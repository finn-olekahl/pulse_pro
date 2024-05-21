import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/createAccount/cubit/create_account_cubit.dart';
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

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

    if (birthDate != null &&
        weight != null &&
        height != null &&
        name != null &&
        gender != null) {
      await context.read<CreateAccountCubit>().createUserObject(context,
          name: name,
          birthdate: birthDate,
          weight: weight,
          height: height,
          gender: gender);

      List<List<String>> split = await context
          .read<CreateAccountCubit>()
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

      WorkoutPlan workoutPlan = await context
          .read<CreateAccountCubit>()
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
      context
          .read<CreateAccountCubit>()
          .updateWorkoutPlans({workoutPlan.id: workoutPlan});
      context
          .read<CreateAccountCubit>()
          .updateCurrentWorkoutPlan(workoutPlan.id);

      print("here should the user be redirected!");
      context.go('/');
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
