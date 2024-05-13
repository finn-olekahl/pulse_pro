import 'package:flutter/material.dart';

class TrainingsPlanView extends StatefulWidget {
  TrainingsPlanView({super.key});

  @override
  State<TrainingsPlanView> createState() => _TrainingsPlanViewState();
}

class _TrainingsPlanViewState extends State<TrainingsPlanView> {
  List<TrainingSplit> _splits = [
    TrainingSplit(title: 'Day 1: Chest/Back', exercises: [
      Exercise(name: 'Bench Press', weights: [100, 105, 110]),
      Exercise(name: 'Pull Ups', weights: [0, 0, 0]),
    ]),
    TrainingSplit(title: 'Day 2: Legs', exercises: [
      Exercise(name: 'Squats', weights: [120, 125, 130]),
      Exercise(name: 'Leg Press', weights: [200, 210, 220]),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Training Plan")),
      body: ListView(
        children: _splits.map<Widget>(_buildSplitPanel).toList(),
      ),
    );
  }

  Widget _buildSplitPanel(TrainingSplit split) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          split.exercises[index].isExpanded = isExpanded;
        });
      },
      children: split.exercises.map<ExpansionPanel>((Exercise exercise) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text(exercise.name));
          },
          body: Column(
            children: exercise.weights.asMap().entries.map((entry) {
              int setNumber = entry.key + 1;
              int weight = entry.value;
              return ListTile(
                title: Text('Set $setNumber: $weight kg'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Implement your logic for changing weights here
                  },
                ),
              );
            }).toList(),
          ),
          isExpanded: exercise.isExpanded,
        );
      }).toList(),
    );
  }
}

class Exercise {
  String name;
  List<int> weights; // Weights for each set of the exercise
  bool isExpanded;

  Exercise({required this.name, required this.weights, this.isExpanded = false});
}

class TrainingSplit {
  String title;
  List<Exercise> exercises;

  TrainingSplit({required this.title, required this.exercises});
}
