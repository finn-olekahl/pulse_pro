import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/shared/models/day_entry.dart';
import 'package:pulse_pro/shared/models/split_day.dart';

class SplitDayCard extends StatefulWidget {
  const SplitDayCard({super.key, required this.splitDay, this.historyDayEntry});

  final SplitDay splitDay;
  final HistoryDayEntry? historyDayEntry;

  @override
  State<SplitDayCard> createState() => _SplitDayCardState();
}

class _SplitDayCardState extends State<SplitDayCard> {
  Timer? _durationTimer;
  Timer? _exerciseTimer;

  Duration? _duration;
  Duration? _exerciseDuration;
  String? _currentExerciseName;

  void _startDurationTimer(DateTime start) {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        _duration = now.difference(start);
      });
    });
  }

  void _resetExerciseTimer(DateTime start) {
    _exerciseDuration = null;
    _exerciseTimer?.cancel();
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        _exerciseDuration = now.difference(start);
      });
    });
  }

  void _stateUpdate(TrainingsPlanState state) {
    if (state.timestamps.isEmpty) return;
    if (_durationTimer == null && state.timestamps.containsKey('start')) {
      _startDurationTimer(state.timestamps['start']!);
    }

    final newestEntry = state.timestamps.entries.reduce((value, element) =>
        value.value.isAfter(element.value) ? value : element);
    if (newestEntry.key == 'start') return;

    if (newestEntry.key == 'end') {
      _durationTimer?.cancel();
      _exerciseTimer?.cancel();
      _exerciseDuration = null;
      return;
    }

    _currentExerciseName = state.exercises[newestEntry.key]?.name;
    _resetExerciseTimer(newestEntry.value);
  }

  @override
  void initState() {
    _stateUpdate(context.read<TrainingsPlanCubit>().state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainingsPlanCubit, TrainingsPlanState>(
      listenWhen: (previous, current) =>
          previous.timestamps.length != current.timestamps.length,
      listener: (context, state) => _stateUpdate(state),
      builder: (context, state) {
        if (widget.historyDayEntry != null) {
          _duration = widget.historyDayEntry!.duration;
        }

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
                        Flexible(flex: 999, child: _getTargetText()),
                        const SizedBox(
                          width: 20,
                        ),
                        if (!state.todayDone)
                          GestureDetector(
                            onTap: () => context
                                .read<TrainingsPlanCubit>()
                                .startTraining(context),
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
                        Text('120min',
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

  Text _getTargetText() {
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
