import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/splitday_view.dart';

class DaysView extends StatefulWidget {
  const DaysView({super.key});

  @override
  State<DaysView> createState() => _DaysViewState();
}

class _DaysViewState extends State<DaysView> {
  final PreloadPageController _pageController = PreloadPageController();
  @override
  void initState() {
    _pageController.addListener(() {
      final index = _pageController.page!;

      final state = context.read<TrainingsPlanCubit>().state;
      if (index < state.history.length) {
        context.read<TrainingsPlanCubit>().updateCurrentDay(state.history[index.toInt()].date);
        return;
      }

      if (index >= state.history.length + (state.todayDone ? 0 : 1)) {
        context
            .read<TrainingsPlanCubit>()
            .updateCurrentDay(state.plan[index.toInt() - (state.history.length + (state.todayDone ? 0 : 1))].date);
        return;
      }

      final now = DateTime.now();
      context.read<TrainingsPlanCubit>().updateCurrentDay(DateTime(now.year, now.month, now.day));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainingsPlanCubit, TrainingsPlanState>(
      listenWhen: (previous, current) =>
          previous.currentDay?.millisecondsSinceEpoch != current.currentDay?.millisecondsSinceEpoch,
      listener: (context, state) {
        if (state.currentDay == null) return;
        final now = DateTime.now();
        final cleanNow = DateTime(now.year, now.month, now.day);
      },
      builder: (context, state) {
        if (state.currentWorkoutPlan == null) {
          return const SizedBox();
        }

        return PreloadPageView.builder(
            controller: _pageController,
            itemCount: state.history.length + state.plan.length + (state.todayDone ? 0 : 1),
            preloadPagesCount: state.history.length + state.plan.length + (state.todayDone ? 0 : 1),
            itemBuilder: (context, index) {
              if (index < state.history.length) {
                return SplitDayView(splitDay: state.history[index].completedSplitDay, exercises: state.exercises, historyDayEntry: state.history[index]);
              }

              if (index >= state.history.length + (state.todayDone ? 0 : 1)) {
                return SplitDayView(
                    splitDay: state.currentWorkoutPlan!
                        .days[state.plan[index - (state.history.length + (state.todayDone ? 0 : 1))].splitDayNumber]!,
                    exercises: state.exercises);
              }

              return SplitDayView(
                  splitDay: state.currentWorkoutPlan!.days[state.currentSplitDay]!, exercises: state.exercises, isToday: true);
            });
      },
    );
  }
}
