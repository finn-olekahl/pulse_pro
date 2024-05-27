import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/splitday_card.dart';
import 'package:pulse_pro/shared/models/split_day.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

class TrainingsPlanView extends StatelessWidget {
  const TrainingsPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 8, 26),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.viewPaddingOf(context).top + 10,
              ),
              BlocBuilder<TrainingsPlanCubit, TrainingsPlanState>(
                  builder: (context, state) {
                final WorkoutPlan? workoutPlan = state.currentWorkoutPlan;
                if (workoutPlan != null) {
                  final SplitDay? splitDay =
                      workoutPlan.days[state.currentSplitDay];
                  if (splitDay != null) ;
                  return SplitDayCard(splitDay: splitDay!);
                }
                return const SizedBox();
              }),
              SizedBox(
                height: MediaQuery.paddingOf(context).bottom + 20,
              ),
            ],
          ),
        ));
  }
}
