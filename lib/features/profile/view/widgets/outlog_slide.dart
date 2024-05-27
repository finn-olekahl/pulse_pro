import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/profile/cubit/profile_cubit.dart';
import 'package:slide_to_act_reborn/slide_to_act_reborn.dart';

class OutlogSlide extends StatelessWidget {
  const OutlogSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      height: 50,
      borderRadius: 30,
      innerColor: Colors.deepPurple.shade300,
      sliderRotate: false,
      outerColor: Colors.deepPurple.shade300.withOpacity(0.2),
      sliderButtonIconSize: 25,
      sliderButtonIconPadding: 5,
      text: 'Slide To Log Out',
      textStyle: TextStyle(
        color: Colors.deepPurple.shade100,
        fontSize: 15,
      ),
      sliderButtonIcon: Icon(
        Icons.arrow_forward,
        color: Colors.deepPurple.shade100,
      ),
      submittedIcon: Icon(
        Icons.done,
        color: Colors.deepPurple.shade100,
      ),
      onSubmit: () => context.read<ProfileCubit>().logout(),
    );
  }
}
