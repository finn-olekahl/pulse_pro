import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/inverted_image.dart';
import 'package:pulse_pro/shared/helpers/capitalize.dart';
import 'package:pulse_pro/shared/helpers/enum_to_text.dart';
import 'package:pulse_pro/shared/models/split_day.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => WorkoutViewState();
}

class WorkoutViewState extends State<WorkoutView> {
  int currentExercise = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      body: SafeArea(
        child: BlocBuilder<TrainingsPlanCubit, TrainingsPlanState>(
          builder: (context, state) {
            final WorkoutPlan? workoutPlan = state.currentWorkoutPlan;
            if (workoutPlan != null) {
              final SplitDay? splitDay =
                  workoutPlan.days[state.currentSplitDay];
              if (splitDay != null && splitDay.exercises != null) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              "Progress:  ",
                              style: TextStyle(
                                  color: Colors.deepPurple.shade200,
                                  fontFamily: 'sansman'),
                            ),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double barWidth = constraints.maxWidth;
                                  int totalPages =
                                      splitDay.exercises?.length ?? 0;
                                  double filledWidth = barWidth *
                                      currentExercise /
                                      (totalPages - 1);
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.shade100
                                              .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(1.5),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeOutCubic,
                                        height: 3,
                                        width: filledWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.shade100,
                                          borderRadius:
                                              BorderRadius.circular(1.5),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.1),
                            border: Border.all(
                              color:
                                  Colors.deepPurple.shade300.withOpacity(0.15),
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text('Exercise ${currentExercise + 1}:',
                                          style: TextStyle(
                                              color: Colors.deepPurple.shade100
                                                  .withOpacity(0.6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                          capitalize(state
                                              .exercises[splitDay
                                                  .exercises![currentExercise]
                                                  .id]!
                                              .name),
                                          style: TextStyle(
                                              color: Colors.deepPurple.shade100,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Exertion Level: ',
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade100
                                              .withOpacity(0.5)),
                                    ),
                                    Text(
                                      enumToText(splitDay
                                          .exercises![currentExercise]
                                          .effortLevel
                                          .name),
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade100,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sets: ',
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade100
                                              .withOpacity(0.5)),
                                    ),
                                    Text(
                                      splitDay.exercises![currentExercise].sets
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade100,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Reps Per Set: ',
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade100
                                              .withOpacity(0.5)),
                                    ),
                                    Text(
                                      splitDay.exercises![currentExercise].reps
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade100,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Seconds Between Sets: ',
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade100
                                              .withOpacity(0.5)),
                                    ),
                                    Text(
                                      (splitDay.exercises![currentExercise]
                                                  .timeBetweenSets /
                                              1000)
                                          .round()
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade100,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.75),
                                        border: Border.all(
                                            strokeAlign:
                                                BorderSide.strokeAlignOutside,
                                            width: 2,
                                            color: Colors.deepPurple.shade300
                                                .withOpacity(0.15)),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                          state
                                              .exercises[splitDay
                                                  .exercises![currentExercise]
                                                  .id]!
                                              .instructions
                                              .length,
                                          (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 15, right: 15),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${index + 1}: ',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .deepPurple.shade100
                                                            .withOpacity(0.5)),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      capitalize(state
                                                          .exercises[splitDay
                                                              .exercises![
                                                                  currentExercise]
                                                              .id]!
                                                          .instructions[index]),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .deepPurple
                                                              .shade100
                                                              .withOpacity(
                                                                  0.8)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )..addAll([
                                            Padding(
                                              padding: const EdgeInsets.all(40),
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: InvertedImage(
                                                  imageProvider: state
                                                      .exercises[splitDay
                                                          .exercises![
                                                              currentExercise]
                                                          .id]!
                                                      .gif,
                                                ),
                                              ),
                                            ),
                                          ]),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: OutlinedButton(
                                  clipBehavior: Clip.antiAlias,
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor:
                                        Colors.deepPurple.withOpacity(0.3),
                                    disabledBackgroundColor:
                                        Colors.deepPurple.withOpacity(0.15),
                                    foregroundColor: Colors.white,
                                    disabledForegroundColor:
                                        Colors.white.withOpacity(0.5),
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: currentExercise <
                                          splitDay.exercises!.length - 1
                                      ? () {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) =>
                                                CupertinoAlertDialog(
                                              title: const Text("Skip?"),
                                              content: const Text(
                                                  "Do you really want to skip this exercise? This cannot be undone."),
                                              actions: [
                                                CupertinoDialogAction(
                                                  onPressed: () =>
                                                      context.pop(),
                                                  child: const Text("Cancel"),
                                                ),
                                                CupertinoDialogAction(
                                                  isDestructiveAction: true,
                                                  onPressed: () {
                                                    setState(() {
                                                      currentExercise++;
                                                    });
                                                    context.pop();
                                                  },
                                                  child: const Text("Skip"),
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      : null,
                                  child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOutQuad,
                                      height: 50,
                                      child: const Center(
                                          child: Text(
                                        'Skip Exercise',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ))),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 3,
                                child: OutlinedButton(
                                  clipBehavior: Clip.antiAlias,
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.deepPurple,
                                    disabledBackgroundColor:
                                        Colors.deepPurple.withOpacity(0.5),
                                    foregroundColor: Colors.white,
                                    disabledForegroundColor:
                                        Colors.white.withOpacity(0.5),
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: currentExercise <
                                          splitDay.exercises!.length - 1
                                      ? () {
                                          setState(() {
                                            currentExercise++;
                                          });
                                        }
                                      : () async {
                                          context
                                              .read<TrainingsPlanCubit>()
                                              .finishTraining()
                                              .then(
                                            (value) {
                                              context.pushReplacement('/');
                                            },
                                          );
                                        },
                                  child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOutQuad,
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        currentExercise <
                                                splitDay.exercises!.length - 1
                                            ? 'Next Exercise'
                                            : 'Finish Workout',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ))),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ));
          },
        ),
      ),
    );
  }
}
