import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';

class TrainingsPlanView extends StatefulWidget {
  const TrainingsPlanView({super.key});

  @override
  State<TrainingsPlanView> createState() => _TrainingsPlanViewState();
}

class _TrainingsPlanViewState extends State<TrainingsPlanView> {
  final Map<int, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training Plan')),
      body: BlocBuilder<TrainingsPlanCubit, TrainingsPlanState>(
        builder: (context, state) {
          if (state.currentWorkoutPlan == null) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ExpansionPanel> expansionPanels = [];
          final splitDay = state.currentWorkoutPlan!.days[0];
          if (splitDay == null || splitDay.restDay || splitDay.exercises == null) return const SizedBox();

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
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(exercise.id),
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

          return Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) =>
                    setState(() => _expanded[panelIndex] = isExpanded),
                children: expansionPanels,
              ),
            ],
          );
        },
      ),
    );
  }
}
