import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/create_account/cubit/create_account_cubit.dart';
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
    startAccountAndWorkoutPlanGeneration();
    super.initState();
  }

  String loadingText(BuildContext context) {
    if (context.watch<CreateAccountCubit>().state is CreateAccountInitial) {
      return "Waiting...";
    } else if (context.watch<CreateAccountCubit>().state is CreatingAccount) {
      return "Setting Up Your Account...";
    } else if (context.watch<CreateAccountCubit>().state is GeneratingSplit) {
      return "Workout Split Generation in Progress...";
    } else if (context.watch<CreateAccountCubit>().state
        is GeneratingWorkoutPlan) {
      return "Generating Your Workout Plan...";
    } else if (context.watch<CreateAccountCubit>().state is AddingWorkoutPlan) {
      return "Adding Workout Plan to Your Account...";
    }
    return "";
  }

  Future<void> startAccountAndWorkoutPlanGeneration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final gender = prefs.getString('gender');
    final name = prefs.getString('name');
    final workoutGoal = prefs.getString('workoutGoal');
    final workoutIntensity = prefs.getString('workoutIntensity');
    final maxTimesPerWeek = prefs.getInt('maxTimesPerWeek');
    final timePerDay = prefs.getInt('timePerDay');
    final injuries = prefs.getStringList('injur ies');
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
          print("generating split....");
      List<List<String>> split = await context
          .read<CreateAccountCubit>()
          .generateSplit(
              gender: gender,
              workoutGoal: workoutGoal!,
              workoutIntensity: workoutIntensity!,
              maxTimesPerWeek: maxTimesPerWeek!,
              timePerDay: timePerDay!,
              injuries: injuries ?? [],
              muscleFocus: muscleFocus ?? [],
              sportOrientation: sportOrientation!,
              workoutExperience: workoutExperience!);

      print("generating workout plan....");
      WorkoutPlan workoutPlan = await context
          .read<CreateAccountCubit>()
          .generateWorkoutPlan(
              split: split,
              gender: gender,
              workoutGoal: workoutGoal,
              workoutIntensity: workoutIntensity,
              timePerDay: timePerDay,
              injuries: injuries ?? [],
              muscleFocus: muscleFocus ?? [],
              sportOrientation: sportOrientation,
              workoutExperience: workoutExperience);

      log(workoutPlan.toJson().toString());
            await context.read<CreateAccountCubit>().createUserObject(
          name: name,
          birthdate: birthDate,
          weight: weight,
          height: height,
          gender: gender);
      print("updating workout plans....");
      await context
          .read<CreateAccountCubit>()
          .updateWorkoutPlans({workoutPlan.id: workoutPlan});
      print("update current workout plan....");
      await context
          .read<CreateAccountCubit>()
          .updateCurrentWorkoutPlan(workoutPlan.id);

      print("redirect....");
      context.read<AppStateBloc>().add(const LocalUserLookUp());
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SettingUpText(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    loadingText(context),
                    style: TextStyle(color: Colors.white.withOpacity(0.75)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SettingUpText extends StatefulWidget {
  @override
  _SettingUpTextState createState() => _SettingUpTextState();
}

class _SettingUpTextState extends State<SettingUpText> {
  final String _text = "Setting up";
  final List<String> _dots = [".", "..", "...", "....", "....."];
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _index = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _index++;
        if (_index == _dots.length) {
          _timer?.cancel();
          _startTimer();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "$_text\n${_dots[_index]}",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'sansman',
        color: Colors.white.withOpacity(0.75),
        fontSize: 30,
      ),
    );
  }
}
