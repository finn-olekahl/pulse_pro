part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState._({
    this.name = '',
    this.gender,
    this.birthDate,
    this.weight,
    this.height,
    this.workoutGoal,
    this.workoutIntensity,
    this.workoutExperience,
    this.maxTimesPerWeek,
    this.timePerDay = 60,
    this.injuries = const [],
    this.muscleFocus = const [],
    this.sportOrientation,
    this.split,
  });

  const LoginState.initial() : this._();

  final String name;
  final Gender? gender;
  final DateTime? birthDate;
  final double? weight;
  final int? height;
  final WorkoutGoal? workoutGoal;
  final WorkoutIntensity? workoutIntensity;
  final WorkoutExperience? workoutExperience;
  final int? maxTimesPerWeek;
  final int timePerDay;
  final List<Injuries> injuries;
  final List<MuscleGroup> muscleFocus;
  final SportOrientation? sportOrientation;
  final List<List<String>>? split;

  @override
  List<Object?> get props => [
        name,
        gender,
        birthDate,
        weight,
        height,
        workoutGoal,
        workoutIntensity,
        workoutExperience,
        maxTimesPerWeek,
        timePerDay,
        injuries,
        muscleFocus,
        sportOrientation,
        split
      ];

  LoginState copyWith({
    String? name,
    Gender? gender,
    DateTime? birthDate,
    double? weight,
    int? height,
    WorkoutGoal? workoutGoal,
    WorkoutIntensity? workoutIntensity,
    WorkoutExperience? workoutExperience,
    int? maxTimesPerWeek,
    int? timePerDay,
    List<Injuries>? injuries,
    List<MuscleGroup>? muscleFocus,
    SportOrientation? sportOrientation,
    List<List<String>>? split,
  }) {
    return LoginState._(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      workoutGoal: workoutGoal ?? this.workoutGoal,
      workoutIntensity: workoutIntensity ?? this.workoutIntensity,
      workoutExperience: workoutExperience ?? this.workoutExperience,
      maxTimesPerWeek: maxTimesPerWeek ?? this.maxTimesPerWeek,
      timePerDay: timePerDay ?? this.timePerDay,
      injuries: injuries ?? this.injuries,
      muscleFocus: muscleFocus ?? this.muscleFocus,
      sportOrientation: sportOrientation ?? this.sportOrientation,
      split: split ?? this.split,
    );
  }
}