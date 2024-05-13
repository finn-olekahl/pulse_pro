import 'package:flutter/material.dart';

class TrainingsPlanView extends StatefulWidget {
  const TrainingsPlanView({super.key});

  @override
  State<TrainingsPlanView> createState() => _TrainingsPlanViewState();
}

class _TrainingsPlanViewState extends State<TrainingsPlanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Training Plan")),
      body: const Placeholder(),
    );
  }
}