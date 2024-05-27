part of 'workout_cubit.dart';

sealed class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object> get props => [];
}

final class WorkoutInitial extends WorkoutState {}
