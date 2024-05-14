import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/home/cubit/home_cubit.dart';
import 'package:pulse_pro/features/home/view/home_view.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    
    context.read<AppStateBloc>().stream.listen((event) {
      print(event);
    });

    print(context.read<AppStateBloc>().state);

    return BlocProvider(
      create: (context) => HomeCubit(authenticationRepository: context.read<AuthenticationRepository>()),
      child: HomeView(),
    );
  }
}
