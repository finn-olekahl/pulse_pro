import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Home'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
