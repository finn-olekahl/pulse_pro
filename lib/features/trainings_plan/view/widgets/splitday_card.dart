import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/shared/models/day_entry.dart';
import 'package:pulse_pro/shared/models/split_day.dart';
import 'package:pulse_pro/shared/models/user_exercise.dart';

class SplitDayCard extends StatefulWidget {
  const SplitDayCard({super.key, required this.splitDay, this.historyDayEntry});

  final SplitDay splitDay;
  final HistoryDayEntry? historyDayEntry;

  @override
  State<SplitDayCard> createState() => _SplitDayCardState();
}

class _SplitDayCardState extends State<SplitDayCard> {
  String getDuration() {
    int duration = 0;
    if (widget.splitDay.warmUp != null) {
      duration += widget.splitDay.warmUp!.duration;
    }
    for (int i = 0; i < widget.splitDay.exercises!.length; i++) {
      duration += (widget.splitDay.timeBetweenExercises! / 1000 / 60).round();
    }
    for (UserExercise exercise in widget.splitDay.exercises!) {
      duration += (exercise.sets * 0.5).round();
      duration += (((exercise.sets - 1) * exercise.timeBetweenSets) / 1000 / 60)
          .round();
    }

    return "${duration}min";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingsPlanCubit, TrainingsPlanState>(
      builder: (context, state) {
        return Center(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  border: Border.all(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      width: 2,
                      color: Colors.deepPurple.shade300.withOpacity(0.15)),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(flex: 999, child: getTargetText()),
                        const SizedBox(
                          width: 20,
                        ),
                        if (!state.todayDone)
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<TrainingsPlanCubit>()
                                  .startTraining(context)
                                  .then(
                                (value) {
                                  context.push('/workoutPage');
                                },
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0))),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        if (state.todayDone)
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(999.0))),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "Training Done!",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text('Duration',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: Colors.deepPurple.shade100)),
                        const Spacer(),
                        Text(getDuration(),
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.deepPurple.shade100))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Text getTargetText() {
    if (widget.splitDay.restDay) return const Text('Rest Day');
    return Text(
      widget.splitDay.target!.map((entry) {
        String str = entry.toString().split('.').last;
        return '${str[0].toUpperCase()}${str.substring(1)}';
      }).join(' & '),
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
          color: Colors.deepPurple.shade100),
    );
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");
}
