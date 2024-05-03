import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/tutorial/tutorial_page.dart';
import 'package:pulse_pro/features/home/cubit/home_cubit.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(authenticationRepository: context.read<AuthenticationRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fitness App'),
        ),
        body: const HomePageContent(),
        backgroundColor: Colors.grey[200], // Hintergrundfarbe ändern
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
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
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TutorialPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Ändere die Hintergrundfarbe des Buttons
                    textStyle: const TextStyle(fontSize: 18), // Ändere die Schriftgröße des Textes
                  ),
                  child: const Text('Tutorial'),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.grey[300], // Hintergrundfarbe der Leiste
          height: 100, // Vergrößere die Höhe der Leiste
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
                  ),
                  const SizedBox(height: 4), // Abstand unter dem Text
                  const Text('Tagebuch'),
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
                  ),
                  const SizedBox(height: 4), // Abstand unter dem Text
                  const Text('Trainingspläne'),
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
                  ),
                  const SizedBox(height: 4), // Abstand unter dem Text
                  const Text('Fortschritte'),
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
                  ),
                  const SizedBox(height: 4), // Abstand unter dem Text
                  const Text('Profil'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
