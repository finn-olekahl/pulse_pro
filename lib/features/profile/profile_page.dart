import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/profile/cubit/profile_cubit.dart';
import 'package:pulse_pro/features/profile/view/profile_view.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(appStateBloc: context.read<AppStateBloc>(), authenticationRepository: context.read<AuthenticationRepository>()),
      child: const ProfileView(),
    );
  }
}
