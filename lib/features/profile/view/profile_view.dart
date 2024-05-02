// ProfileView.dart
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final VoidCallback onCreateProfilePressed;

  const ProfileView({super.key, required this.onCreateProfilePressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil erstellen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Erstelle dein Profil',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Hier könntest du die Widgets für die Profilerstellung hinzufügen
            const Text(
              'Fülle die benötigten Informationen aus:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onCreateProfilePressed,
              child: const Text('Profil erstellen'),
            ),
          ],
        ),
      ),
    );
  }
}
