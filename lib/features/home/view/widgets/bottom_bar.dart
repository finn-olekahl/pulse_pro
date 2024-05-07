import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Höhe der Leiste
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 70, 70, 70)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // Aktion für Tagebuch ausführen
                },
                icon: const Icon(Icons.book),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              const SizedBox(height: 4), // Abstand unter dem Text
              const Text(
                'Tagebuch',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), // Textfarbe ändern
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // Aktion für Trainingspläne ausführen
                },
                icon: const Icon(Icons.fitness_center),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              const SizedBox(height: 4), // Abstand unter dem Text
              const Text(
                'Trainingspläne',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), // Textfarbe ändern
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // Aktion für Fortschritte ausführen
                },
                icon: const Icon(Icons.trending_up),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              const SizedBox(height: 4), // Abstand unter dem Text
              const Text(
                'Fortschritte',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), // Textfarbe ändern
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // Aktion für Profil ausführen
                },
                icon: const Icon(Icons.person),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              const SizedBox(height: 4), // Abstand unter dem Text
              const Text(
                'Profil',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), // Textfarbe ändern
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}