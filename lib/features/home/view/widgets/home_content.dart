import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/home/cubit/home_cubit.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<HomeCubit>().signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Ändere die Hintergrundfarbe des Buttons
                  textStyle: const TextStyle(fontSize: 18), // Ändere die Schriftgröße des Textes
                ),
                child: const Text('Logout'),
              ),
              const SizedBox(height: 20), // Abstand zwischen den Buttons
              ElevatedButton(
                onPressed: () => context.go('/debug'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Ändere die Hintergrundfarbe des Buttons
                  textStyle: const TextStyle(fontSize: 18), // Ändere die Schriftgröße des Textes
                ),
                child: const Text('Tutorial'),
              ),
              const Text(
                'Willkommen zur Fitness App!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0), // Textfarbe ändern
                ),
              ),
              const SizedBox(height: 20), // Abstand zum nächsten Text
              const Text(
                'Entdecke eine neue Dimension des Trainings und der Gesundheit. olor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255), // Textfarbe ändern
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
