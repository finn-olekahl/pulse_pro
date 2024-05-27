import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/workout_page/cubit/workout_cubit.dart';
import 'package:pulse_pro/features/workout_page/view/workout_view.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutCubit(),
      child: const WorkoutView(),
    );
  }
}