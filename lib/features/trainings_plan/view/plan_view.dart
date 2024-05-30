import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/exercise_list_item.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/splitday_card.dart';
import 'package:pulse_pro/shared/models/split_day.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';

class TrainingsPlanView extends StatefulWidget {
  const TrainingsPlanView({super.key});

  @override
  State<TrainingsPlanView> createState() => TrainingsPlanViewState();
}

class TrainingsPlanViewState extends State<TrainingsPlanView> {
  int? openIndex;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _itemKeys = [];
  final GlobalKey listViewKey = GlobalKey();

  void setOpenIndex(int? index, bool closeOnly) {
    setState(() {
      openIndex = index;
    });

    if (index != null) {
      final key = _itemKeys[index];
      final context = key.currentContext;

      if (context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box = key.currentContext!.findRenderObject() as RenderBox?;
          if (box != null) {
            final position = box.localToGlobal(Offset.zero);
            _scrollController.animateTo(
              _scrollController.offset +
                  position.dy -
                  ((listViewKey.currentContext!.findRenderObject()
                              as RenderBox?)!
                          .localToGlobal(Offset.zero)
                          .dy +
                      10),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
    if (closeOnly) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

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
                      _itemKeys.addAll(List.generate(
                          state.currentWorkoutPlan!.days[state.currentSplitDay]!
                              .exercises!.length,
                          (index) => GlobalKey()));
                      if (splitDay != null && splitDay.exercises != null) {
                        return Expanded(
                          child: Column(
                            children: [
                              SplitDayCard(splitDay: splitDay),
                              const SizedBox(
                                height: 20,
                              ),
                              if (state.todayDone)
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.green.withOpacity(0.3)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Congratulations!",
                                              style: TextStyle(
                                                  fontFamily: 'sansman',
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "You Finished Today's Workout!\nKeep It Going, Stay Consistent and Trust the Process to Become the Best Version of Yourself!",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.75)))
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              Flexible(
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.deepPurple.shade300
                                              .withOpacity(0.15),
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside)),
                                  child: ListView.separated(
                                    key: listViewKey,
                                    controller: _scrollController,
                                    clipBehavior: Clip.none,
                                    padding: const EdgeInsets.all(10),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemCount: splitDay.exercises!.length,
                                    itemBuilder: (context, index) =>
                                        ExerciseListItem(
                                      key: _itemKeys[index],
                                      index: index,
                                      exercises: state.exercises,
                                      splitDay: splitDay,
                                      openIndex: openIndex,
                                      setOpenIndex: setOpenIndex,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return const Expanded(
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      )),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.paddingOf(context).bottom + 20,
                ),
              ],
            )));
  }
}
