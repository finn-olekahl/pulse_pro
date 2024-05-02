import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:pulse_pro/features/home/cubit/home_cubit.dart';

class TutorialView extends StatelessWidget {
  final VoidCallback onStartPressed;

  TutorialView({required this.onStartPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness App Tutorial'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Willkommen zur Fitness App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hier ist eine kurze Anleitung, wie du die App verwenden kannst:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            _buildStep('1', 'Erstelle dein Profil: Melde dich an und fülle dein Profil aus.'),
            _buildStep('2', 'Wähle dein Trainingsprogramm: Wähle aus verschiedenen Trainingsprogrammen je nach deinen Zielen.'),
            _buildStep('3', 'Verfolge deine Fortschritte: Nutze die App, um deine Workouts, Fortschritte und Erfolge zu verfolgen.'),
            _buildStep('4', 'Ernährungsplan: Finde passende Ernährungspläne und Tipps für deine Fitnessziele.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onStartPressed,
              child: const Text('Los geht\'s!'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String stepNumber, String stepText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$stepNumber. ',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              stepText,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
