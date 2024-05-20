import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/days_view.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/splitday_view.dart';
import 'package:table_calendar/table_calendar.dart';

class TrainingsPlanView extends StatelessWidget {
  const TrainingsPlanView({super.key});

  StartingDayOfWeek _startingDay(DateTime day) {
    StartingDayOfWeek startingDayOfWeek = StartingDayOfWeek.monday;
    switch (day.weekday) {
      case 1:
        startingDayOfWeek = StartingDayOfWeek.friday;
        break;
      case 2:
        startingDayOfWeek = StartingDayOfWeek.saturday;
        break;
      case 3:
        startingDayOfWeek = StartingDayOfWeek.sunday;
        break;
      case 4:
        startingDayOfWeek = StartingDayOfWeek.monday;
        break;
      case 5:
        startingDayOfWeek = StartingDayOfWeek.tuesday;
        break;
      case 6:
        startingDayOfWeek = StartingDayOfWeek.wednesday;
        break;
      case 7:
        startingDayOfWeek = StartingDayOfWeek.thursday;
        break;
    }
    return startingDayOfWeek;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.viewPaddingOf(context).top),
        child: BlocBuilder<TrainingsPlanCubit, TrainingsPlanState>(
          builder: (context, state) {
            if (state.currentWorkoutPlan == null) {
              return const Center(child: CircularProgressIndicator());
            }
        
            final splitDay = state.currentWorkoutPlan!.days[0];
            if (splitDay == null) return const SizedBox();
        
            return Column(
              children: [
                TableCalendar(
                  focusedDay: state.currentDay ?? DateTime.now(),
                  firstDay: state.history.isEmpty ? DateTime.now() : state.history.first.date,
                  lastDay: state.plan.last.date,
                  rangeSelectionMode: RangeSelectionMode.toggledOff,
                  pageAnimationEnabled: true,
                  calendarFormat: CalendarFormat.week,
                  headerVisible: false,
                  daysOfWeekVisible: true,
                  startingDayOfWeek: _startingDay(state.currentDay ?? DateTime.now()),
                  calendarStyle: const CalendarStyle(
                    isTodayHighlighted: false,
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (isSameDay(day, state.currentDay)) {
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
                    context.read<TrainingsPlanCubit>().updateCurrentDay(selectedDay);
                  },
                ),
                Expanded(child: DaysView())
              ],
            );
          },
        ),
      ),
    );
  }
}
