import 'package:flutter/material.dart';
import 'package:pulse_pro/features/profile/profile_page.dart';

class OnboardingView extends StatelessWidget {
  final VoidCallback onStartPressed;

  const OnboardingView({super.key, required this.onStartPressed});

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
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Gib deinen vollen Namen ein',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Alter',
                hintText: 'Gib dein Alter ein',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Geschlecht',
                hintText: 'Gib dein Geschlecht ein',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Größe (cm)',
                hintText: 'Gib deine Größe in cm ein',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Gewicht (kg)',
                hintText: 'Gib dein Gewicht in kg ein',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
              child: const Text('Los geht\'s!'),
            ),
          ],
        ),
      ),
    );
  }
}
