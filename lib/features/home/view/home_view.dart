import 'package:flutter/material.dart';

import 'package:pulse_pro/features/home/view/widgets/bottom_bar.dart';
import 'package:pulse_pro/features/home/view/widgets/home_content.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness App'),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255), // Transparenter Hintergrund
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 80, 80, 80),
                Color.fromARGB(255, 40, 40, 40),
              ],
            ),
          ),
        ),
      ),
      body: const Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: HomeContent(),
            ),
          ),
          BottomBar(), // Bottom Bar außerhalb des SingleChildScrollView platzieren
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 80, 80, 80), // Hintergrundfarbe ändern
    );
  }
}

