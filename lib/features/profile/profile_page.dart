// ProfilePage.dart
import 'package:flutter/material.dart';
import 'package:pulse_pro/features/home/home_page.dart';
import 'package:pulse_pro/features/profile/view/profile_view.dart';

//import 'package:your_package_name_here/programm_page.dart'; // Importiere die nächste Seite

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileView(
      onCreateProfilePressed: () {
        // Hier könntest du die Logik zur Profilerstellung hinzufügen
        // Zum Beispiel: Speichern der Profilinformationen und Navigation zur nächsten Seite
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      },
    );
  }
}
