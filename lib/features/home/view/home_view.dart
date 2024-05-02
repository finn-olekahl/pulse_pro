import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/home/cubit/home_cubit.dart';
import 'package:pulse_pro/features/tutorial/tutorial_page.dart'; // Importiere die TutorialPage

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Button'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<HomeCubit>().signOut();
              },
              child: const Text('Logout'),
            ),
            const SizedBox(height: 20), // Abstand zwischen den Buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TutorialPage()));
              },
              child: const Text('Tutorial'),
            ),
          ],
        ),
      ),
    );
  }
}
