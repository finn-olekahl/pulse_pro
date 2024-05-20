import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

class CreateAccountLoadingView extends StatefulWidget {
  const CreateAccountLoadingView({super.key});

  State<CreateAccountLoadingView> createState() =>
      _CreateAccountLoadingViewState();
}

class _CreateAccountLoadingViewState extends State<CreateAccountLoadingView> {
  @override
  void initState() {
    startAccountAndWorkoutPlanGeneration();
    super.initState();
  }

  Future<void> startAccountAndWorkoutPlanGeneration() async {
    final loginState = context.read<LoginCubit>().state;
    if (loginState.birthDate != null &&
        loginState.weight != null &&
        loginState.height != null &&
        loginState.gender != null) {
      await context.read<AppStateBloc>().userRepository.createUserObject(
          context,
          name: loginState.name,
          birthdate: loginState.birthDate!.millisecondsSinceEpoch,
          weight: loginState.weight!,
          height: loginState.height!,
          gender: loginState.gender!.name);

      List<List<String>> split = await context
          .read<AppStateBloc>()
          .userRepository
          .generateSplit(context,
              gender: loginState.gender!,
              workoutGoal: loginState.workoutGoal!,
              workoutIntensity: loginState.workoutIntensity!,
              maxTimesPerWeek: loginState.maxTimesPerWeek!,
              timePerDay: loginState.timePerDay,
              injuries: loginState.injuries,
              muscleFocus: loginState.muscleFocus,
              sportOrientation: loginState.sportOrientation!,
              workoutExperience: loginState.workoutExperience!);

      print(split);

      WorkoutPlan workoutPlan = await context
          .read<AppStateBloc>()
          .userRepository
          .generateWorkoutPlan(context,
              split: split,
              gender: loginState.gender!,
              workoutGoal: loginState.workoutGoal!,
              workoutIntensity: loginState.workoutIntensity!,
              timePerDay: loginState.timePerDay,
              injuries: loginState.injuries,
              muscleFocus: loginState.muscleFocus,
              sportOrientation: loginState.sportOrientation!,
              workoutExperience: loginState.workoutExperience!);

      print(workoutPlan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      body: Stack(
        children: [
          Expanded(
              child: Center(
            child: Lottie.asset('assets/lottie/loading.json',
                width: MediaQuery.sizeOf(context).width / 2,
                height: MediaQuery.sizeOf(context).width / 2),
          ))
        ],
      ),
    );
  }
}
