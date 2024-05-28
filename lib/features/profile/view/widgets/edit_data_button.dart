import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/profile/cubit/profile_cubit.dart';

class EditDataButton extends StatelessWidget {
  const EditDataButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade500,
                foregroundColor: Colors.deepPurple.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => context.read<ProfileCubit>().edit(),
              child: Text(
                state.status == ProfileStatus.loaded || state.status == ProfileStatus.initial
                    ? 'Edit Personal Data'
                    : 'Save Personal Data',
                style: TextStyle(
                  color: Colors.deepPurple.shade100,
                  fontSize: 15,
                ),
              )),
        );
      },
    );
  }
}
