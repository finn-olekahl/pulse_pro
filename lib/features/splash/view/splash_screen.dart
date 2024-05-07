import 'package:flutter/material.dart';
import 'package:pulse_pro/app/color_palette.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: columbiaBlue,
      body: Center(child: Text("Splash Screen")),
    );
  }
}