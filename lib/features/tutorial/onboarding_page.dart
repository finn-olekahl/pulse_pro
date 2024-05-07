// TutorialPage.dart
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:pulse_pro/features/home/cubit/home_cubit.dart';
//import 'package:pulse_pro/features/home/view/home_view.dart';
import 'package:pulse_pro/features/tutorial/view/onboarding_view.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialView(
      onStartPressed: () {
        // Hier könntest du die Navigation zur Hauptseite deiner App implementieren
        Navigator.pushNamed(context, '/home');
      },
    );
  }
}
