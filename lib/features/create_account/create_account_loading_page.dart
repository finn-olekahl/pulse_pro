import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/create_account/cubit/create_account_cubit.dart';
import 'package:pulse_pro/features/create_account/view/create_account_loading_view.dart';
import 'package:pulse_pro/repositories/user_repository.dart';

class CreateAccountLoadingPage extends StatelessWidget {
  const CreateAccountLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateAccountCubit(userRepository: UserRepository()),
      child: const CreateAccountLoadingView(),
    );
  }
}
