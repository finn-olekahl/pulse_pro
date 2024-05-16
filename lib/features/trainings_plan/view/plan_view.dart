import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

class TrainingsPlanView extends StatefulWidget {
  const TrainingsPlanView({super.key});

  @override
  State<TrainingsPlanView> createState() => _TrainingsPlanViewState();
}

class _TrainingsPlanViewState extends State<TrainingsPlanView> {
  final Map<int, bool> _expanded = {};

  DateTime _highlightedDay = DateTime(2024, 01, 01);
  StartingDayOfWeek _startingDayOfWeek = StartingDayOfWeek.monday;
  void _changeHighlightedDay(DateTime day) {
    setState(() {
      _highlightedDay = day;

      switch (day.weekday) {
        case 1:
          _startingDayOfWeek = StartingDayOfWeek.friday;
          break;
        case 2:
          _startingDayOfWeek = StartingDayOfWeek.saturday;
          break;
        case 3:
          _startingDayOfWeek = StartingDayOfWeek.sunday;
          break;
        case 4:
          _startingDayOfWeek = StartingDayOfWeek.monday;
          break;
        case 5:
          _startingDayOfWeek = StartingDayOfWeek.tuesday;
          break;
        case 6:
          _startingDayOfWeek = StartingDayOfWeek.wednesday;
          break;
        case 7:
          _startingDayOfWeek = StartingDayOfWeek.thursday;
          break;
      }
    });
  }

  @override
  void initState() {
    _changeHighlightedDay(DateTime.now());
    super.initState();
  }

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
                    title: Text(state.exercises[exercise.id]?.name ?? 'Exercise'),
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
              TableCalendar(
                focusedDay: _highlightedDay,
                firstDay: DateTime.utc(2014, 05, 10),
                lastDay: DateTime.utc(2034, 05, 20),
                rangeSelectionMode: RangeSelectionMode.toggledOff,
                pageAnimationEnabled: true,
                calendarFormat: CalendarFormat.week,
                headerVisible: false,
                daysOfWeekVisible: true,
                startingDayOfWeek: _startingDayOfWeek,
                calendarStyle: const CalendarStyle(
                  isTodayHighlighted: false,
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (isSameDay(day, _highlightedDay)) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple, // Highlight color
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                pageAnimationCurve: Curves.linear,
                pageAnimationDuration: const Duration(milliseconds: 1),
                onDaySelected: (selectedDay, focusedDay) {
                  _changeHighlightedDay(selectedDay);
                },
              ),
              ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) => setState(() => _expanded[panelIndex] = isExpanded),
                children: expansionPanels,
              ),
            ],
          );
        },
      ),
    );
  }
}
