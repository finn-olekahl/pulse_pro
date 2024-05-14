class UserExercise {
  final String id;
  final int sets;
  final int reps;
  final EffortLevel effortLevel;
  final int timeBetweenSets;
  final Map<int, int>? weights;

  UserExercise(
      {required this.id,
      required this.sets,
      required this.reps,
      required this.effortLevel,
      required this.timeBetweenSets,
      this.weights});

  UserExercise copyWith({
    String? id,
    int? sets,
    int? reps,
    EffortLevel? effortLevel,
    int? timeBetweenSets,
    Map<int, int>? weights,
  }) =>
      UserExercise(
        id: id ?? this.id,
        sets: sets ?? this.sets,
        reps: reps ?? this.reps,
        effortLevel: effortLevel ?? this.effortLevel,
        timeBetweenSets: timeBetweenSets ?? this.timeBetweenSets,
        weights: weights ?? this.weights,
      );

  factory UserExercise.fromJson(Map<String, dynamic> json) {
    return UserExercise(
      id: json['id'],
      sets: json['sets'],
      reps: json['reps'],
      effortLevel: EffortLevel.values.firstWhere((e) => e.toString() == 'EffortLevel.${json['effort_level']}'),
      timeBetweenSets: json['time_between_sets'],
      weights: json['weights']?.map((key, value) => MapEntry(int.parse(key), value)).cast<int, int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sets': sets,
      'reps': reps,
      'effort_level': effortLevel.toString().split('.').last,
      'time_between_sets': timeBetweenSets,
      'weights': weights?.map((key, value) => MapEntry(key.toString(), value)),
    };
  }
}

enum EffortLevel {
  lightExertion,
  moderateExertion,
  heavyExertion,
  failure,
}
