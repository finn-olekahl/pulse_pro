import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/splitday_view.dart';

class DaysView extends StatefulWidget {
  const DaysView({super.key});

  @override
  State<DaysView> createState() => _DaysViewState();
}

class _DaysViewState extends State<DaysView> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    _pageController.addListener(() {
      final index = _pageController.page!;
      if (index != index.toInt().toDouble()) return;

      final state = context.read<TrainingsPlanCubit>().state;
      if (index < state.history.length) {
        context.read<TrainingsPlanCubit>().updateCurrentDay(state.history[index.toInt()].date);
        return;
      }

      if (index >= state.history.length + 1) {
        context
            .read<TrainingsPlanCubit>()
            .updateCurrentDay(state.plan[index.toInt() - (state.history.length + 1)].date);
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

        if (state.currentDay!.compareTo(cleanNow) < 0) {
          final index = state.history.indexWhere((element) => element.date.compareTo(state.currentDay!) == 0);
          setState(() {
            _pageController.jumpToPage(index);
          });
          return;
        }

        if (state.currentDay!.compareTo(cleanNow) > 0) {
          final index = state.plan.indexWhere((element) => element.date.compareTo(state.currentDay!) == 0);
          setState(() {
            _pageController.jumpToPage(index + state.history.length + 1);
          });
          return;
        }

        setState(() {
          _pageController.jumpToPage(state.history.length);
        });
      },
      builder: (context, state) {
        if (state.currentWorkoutPlan == null) {
          return const SizedBox();
        }

        return PageView.builder(
            controller: _pageController,
            itemCount: state.history.length + state.plan.length + 1,
            itemBuilder: (context, index) {
              if (index < state.history.length) {
                return SplitDayView(splitDay: state.history[index].completedSplitDay, exercises: state.exercises);
              }

              if (index >= state.history.length + 1) {
                return SplitDayView(
                    splitDay:
                        state.currentWorkoutPlan!.days[state.plan[index - (state.history.length + 1)].splitDayNumber]!,
                    exercises: state.exercises);
              }

              return SplitDayView(
                  splitDay: state.currentWorkoutPlan!.days[state.currentSplitDay]!, exercises: state.exercises);
            });
      },
    );
  }
}
