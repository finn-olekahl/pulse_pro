import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/splitday_card.dart';
import 'package:pulse_pro/shared/models/exercise.dart';
import 'package:pulse_pro/shared/models/split_day.dart';

class SplitDayView extends StatefulWidget {
  const SplitDayView({super.key, required this.splitDay, required this.exercises});

  final SplitDay splitDay;
  final Map<String, Exercise> exercises;

  @override
  State<SplitDayView> createState() => _SplitDayViewState();
}

class _SplitDayViewState extends State<SplitDayView> {
  final Map<int, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SplitDayCard(splitDay: widget.splitDay),
          Spacer(
            flex: 1,
          ),
          Text('Progress', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) => setState(() => _expanded[panelIndex] = isExpanded),
            children: _getExercisesView(),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 60,
          )
        ],
      ),
    );
  }

  List<ExpansionPanel> _getExercisesView() {
    final splitDay = widget.splitDay;
    if (splitDay.restDay || splitDay.exercises == null) return [];

    final List<ExpansionPanel> expansionPanels = [];
    int index = 0;

    for (final exercise in splitDay.exercises!) {
      final listTiles = <Widget>[];
      for (int i = 0; i < exercise.sets; i++) {
        final int? weight = exercise.weights?[i];

        listTiles.add(
          ListTile(
            title: Text('Set ${i + 1}${weight != null ? ' - $weight kg' : ''}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.read<TrainingsPlanCubit>().updateExerciseWeight(exercise, 0, i, 10);
              },
            ),
          ),
        );
      }

      expansionPanels.add(
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(widget.exercises[exercise.id]?.name ?? 'Exercise'),
            );
          },
          body: Column(
            children: listTiles,
          ),
          isExpanded: _expanded[index] ?? false,
        ),
      );

      index++;
    }

    return expansionPanels;
  }
}
