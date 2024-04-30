import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/home/cubit/home_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Button'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<HomeCubit>().signOut();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}