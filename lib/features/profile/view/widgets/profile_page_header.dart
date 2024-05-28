import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/profile/cubit/profile_cubit.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';

class ProfilePageHeader extends StatelessWidget {
  const ProfilePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.viewPaddingOf(context).top,
                  left: 20,
                  right: MediaQuery.sizeOf(context).width * 1 / 4),
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Stay Strong,\n',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 25,
                      ),
                    ),
                    TextSpan(
                      text: "${state.pulseProUser!.name}!",
                      style: TextStyle(
                        color: Colors.deepPurple.shade300,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(MediaQuery.sizeOf(context).width * 1 / 3, -MediaQuery.sizeOf(context).width * 0.05),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.666,
                      child: state.pulseProUser!.gender == Gender.female
                          ? Image.asset('assets/images/avatar_female.png')
                          : Image.asset('assets/images/avatar_male.png'))),
            ),
          ],
        );
      },
    );
  }
}
