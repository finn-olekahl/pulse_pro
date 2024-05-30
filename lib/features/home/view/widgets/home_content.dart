import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/home/cubit/home_cubit.dart';
import 'package:pulse_pro/features/home/view/widgets/muscle_indicator.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/repositories/exercise_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';
import 'package:pulse_pro/shared/helpers/enum_to_text.dart';
import 'package:pulse_pro/shared/models/split_day.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrainingsPlanCubit(
          appStateBloc: context.read<AppStateBloc>(),
          userRepository: context.read<UserRepository>(),
          exerciseRepository: context.read<ExerciseRepository>()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 8, 26),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.viewPaddingOf(context).top,
                bottom: MediaQuery.paddingOf(context).bottom + 20),
            child: BlocBuilder<TrainingsPlanCubit, TrainingsPlanState>(
              builder: (context, state) {
                final WorkoutPlan? workoutPlan = state.currentWorkoutPlan;
                if (workoutPlan != null) {
                  final SplitDay? splitDay =
                      workoutPlan.days[state.currentSplitDay];
                  if (splitDay != null && splitDay.exercises != null) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                border: Border.all(
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    width: 2,
                                    color: Colors.deepPurple.shade300
                                        .withOpacity(0.15)),
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text.rich(
                                      textAlign: TextAlign.center,
                                      TextSpan(
                                          style: const TextStyle(
                                              fontFamily: 'sansman',
                                              fontSize: 22.5),
                                          children: [
                                            TextSpan(
                                              text: "Today's ",
                                              style: TextStyle(
                                                  color: Colors
                                                      .deepPurple.shade100),
                                            ),
                                            const TextSpan(
                                              text: "Workout",
                                              style: TextStyle(
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ])),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.deepPurple.shade300
                                          .withOpacity(0.1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 4,
                                                child: Text(
                                                  splitDay.target!.map((entry) {
                                                    String str = enumToText(
                                                        entry
                                                            .toString()
                                                            .split('.')
                                                            .last);
                                                    return str;
                                                  }).join(' & '),
                                                  style: TextStyle(
                                                      fontSize: 27,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors
                                                          .deepPurple.shade100),
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: MuscleIndicator(
                                            silhouetteColor: Colors
                                                .deepPurple.shade300
                                                .withOpacity(0.3),
                                            muscleBaseColor: Colors
                                                .deepPurple.shade300
                                                .withOpacity(0.15),
                                            muscleHighlightColor: Colors
                                                .deepPurple.shade300
                                                .withOpacity(1),
                                            muscleGroups: splitDay.target!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple.shade400,
                                    disabledBackgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    disabledForegroundColor: Colors.white,
                                    side: BorderSide(
                                      color:
                                          Colors.transparent.withOpacity(0.3),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: state.todayDone
                                      ? null
                                      : () {
                                          context
                                              .read<HomeCubit>()
                                              .dockController
                                              .jumpTo(2);
                                        },
                                  child: SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        state.todayDone
                                            ? 'Workout Completed!'
                                            : 'Start Workout',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15),
                                      ))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Transform.translate(
                  offset: Offset(
                      0,
                      (MediaQuery.sizeOf(context).height -
                              MediaQuery.viewPaddingOf(context).top -
                              (MediaQuery.viewPaddingOf(context).bottom +
                                  20 +
                                  100)) /
                          2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
