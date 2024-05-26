import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/custom_expansionpanel.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/splitday_card.dart';
import 'package:pulse_pro/shared/models/day_entry.dart';
import 'package:pulse_pro/shared/models/exercise.dart';
import 'package:pulse_pro/shared/models/split_day.dart';
import 'package:pulse_pro/shared/models/user_exercise.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SplitDayView extends StatefulWidget {
  const SplitDayView({super.key, required this.splitDay, this.historyDayEntry, required this.exercises});

  final SplitDay splitDay;
  final HistoryDayEntry? historyDayEntry;
  final Map<String, Exercise> exercises;

  @override
  State<SplitDayView> createState() => _SplitDayViewState();
}

class _SplitDayViewState extends State<SplitDayView> {
  final PanelController _panelController = PanelController();

  UserExercise? _selectedExercise;
  int? _selectedSet;
  double? _selectedWeight = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SplitDayCard(splitDay: widget.splitDay),
              const Spacer(
                flex: 1,
              ),
              const Text('Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
              ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                children: _getExercisesView(),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 60,
              )
            ],
          ),
        ),
        SlidingUpPanel(
          color: Colors.transparent,
          boxShadow: null,
          backdropTapClosesPanel: true,
          backdropEnabled: true,
          controller: _panelController,
          panelBuilder: (scrollController) => _getSlidingUpPanel(),
          defaultPanelState: PanelState.CLOSED,
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          minHeight: 0,
        )
      ],
    );
  }

  Widget _getSetWeightView() {
    if (_selectedExercise == null || _selectedSet == null) return const SizedBox();

    final double lastWeight = _selectedExercise!.weights![_selectedSet] ?? 0;

    return Flexible(
      child: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          Text(
            'Last time',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 32,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            lastWeight.toString(),
            style: TextStyle(fontFamily: 'sansman', fontSize: 35, color: Colors.deepPurple.shade500.withOpacity(0.6)),
          ),
          const Spacer(
            flex: 1,
          ),
          Text(
            'Your new weight',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 32,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AnimatedWeightPicker(
            min: 0,
            max: 300,
            dialColor: Colors.deepPurple.shade200,
            selectedValueColor: Colors.deepPurple.shade500,
            suffixTextColor: Colors.deepPurple.shade300,
            majorIntervalColor: Colors.deepPurple.shade200,
            subIntervalColor: Colors.white,
            minorIntervalColor: Colors.white,
            subIntervalTextColor: Colors.white,
            majorIntervalTextColor: Colors.white,
            minorIntervalTextColor: Colors.white,
            squeeze: 4,
            dialHeight: 45,
            division: 0.5,
            selectedValueStyle: TextStyle(fontFamily: 'sansman', fontSize: 30, color: Colors.deepPurple.shade500),
            onChange: (newValue) {
              setState(() {
                _selectedWeight = double.parse(newValue);
              });
            },
          ),
          const Spacer(
            flex: 1,
          ),
          OutlinedButton(
            clipBehavior: Clip.antiAlias,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white.withAlpha(30),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.white.withAlpha(15),
              disabledForegroundColor: Colors.white.withAlpha(60),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              context.read<TrainingsPlanCubit>().updateExerciseWeight(
                  _selectedExercise!, widget.splitDay.dayNumber, _selectedSet!, _selectedWeight ?? 0);
              _panelController.close();
              _selectedExercise = null;
              _selectedSet = null;
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutQuad,
                height: 50,
                color: Colors.deepPurple,
                child: const Center(
                    child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ))),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  Widget _getSlidingUpPanel() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Container(
            color: const Color.fromARGB(255, 15, 8, 26),
          ),
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 10),
                        child: Center(
                          child: Text(
                            'Exercise: ${widget.exercises[_selectedExercise?.id]?.name ?? 'Exercise'}',
                            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      _getSetWeightView(),
                    ],
                  )),
            )
          ],
        ),
      ],
    );
  }

  List<CustomExpansionPanel> _getExercisesView() {
    final splitDay = widget.splitDay;
    if (splitDay.restDay || splitDay.exercises == null) return [];

    final List<CustomExpansionPanel> expansionPanels = [];

    for (final exercise in splitDay.exercises!) {
      final listTiles = <Widget>[];
      for (int i = 0; i < exercise.sets; i++) {
        final double? weight = exercise.weights?[i];

        listTiles.add(
          BlocBuilder<TrainingsPlanCubit, TrainingsPlanState>(
            builder: (context, state) {
              if (state.progress[exercise.id] != null && state.progress[exercise.id]![i] != null) {
                return ListTile(
                  title: Text('Set ${i + 1}: $weight kg'),
                  trailing: const Icon(Icons.done),
                );
              }

              return ListTile(
                title: Text('Set ${i + 1}: ${exercise.reps} reps ${weight != null ? '($weight kg)' : ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => setState(() {
                    _selectedExercise = exercise;
                    _selectedSet = i;
                    _panelController.open();
                  }),
                ),
              );
            },
          ),
        );
      }

      bool isFinished = context.watch<TrainingsPlanCubit>().state.todayDone ||
          (context.watch<TrainingsPlanCubit>().state.progress[exercise.id] != null &&
              context.watch<TrainingsPlanCubit>().state.progress[exercise.id]!.length == exercise.sets);

      expansionPanels.add(CustomExpansionPanel(
          title: Text('${widget.exercises[exercise.id]?.name ?? 'Exercise'} ${exercise.sets}x${exercise.reps}'),
          body: Column(
            children: listTiles,
          ),
          isFinished: isFinished));
    }

    return expansionPanels;
  }
}
