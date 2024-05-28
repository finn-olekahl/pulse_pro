import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/profile/cubit/profile_cubit.dart';
import 'package:pulse_pro/features/profile/view/widgets/edit_data_button.dart';
import 'package:pulse_pro/features/profile/view/widgets/logout_slide.dart';
import 'package:pulse_pro/features/profile/view/widgets/profile_detail.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.pulseProUser == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.viewPaddingOf(context).top,
                        left: 20,
                        right: MediaQuery.sizeOf(context).width * 1 / 4),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                            fontSize: 24.0, fontFamily: 'sansman'),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Stay Strong,\n',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 28,
                            ),
                          ),
                          TextSpan(
                            text: state.pulseProUser!.name,
                            style: TextStyle(
                              color: Colors.deepPurple.shade300,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(MediaQuery.sizeOf(context).width * 1 / 3,
                        -MediaQuery.sizeOf(context).width * 0.05),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.666,
                            child: state.pulseProUser!.gender == Gender.female
                                ? Image.asset('assets/images/avatar_female.png')
                                : Image.asset(
                                    'assets/images/avatar_male.png'))),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top:
                        MediaQuery.sizeOf(context).width * (2 / 3 - 0.05) - 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                        color: Colors.deepPurple.shade300.withOpacity(0.15),
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ProfileDetail(
                                  label: 'Age',
                                  value: calculateAge(
                                          state.pulseProUser!.birthDate)
                                      .toString()),
                              const SizedBox(
                                width: 10,
                              ),
                              ProfileDetail(
                                  label: 'Gender',
                                  value: capitalize(state.pulseProUser!.gender
                                      .toString()
                                      .split('.')
                                      .last))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ProfileDetail(
                                  label: 'Height',
                                  value: '${state.pulseProUser!.height} cm'),
                              const SizedBox(
                                width: 10,
                              ),
                              ProfileDetail(
                                  label: 'Weight',
                                  value: '${state.pulseProUser!.weight} kg')
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const EditDataButton(),
                          const Spacer(),
                          const OutlogSlide(),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              onTap: () => context.push('/licenses'),
                              child: Text(
                                'Open Source Licenses',
                                style: TextStyle(
                                    color: Colors.deepPurple.shade200
                                        .withOpacity(0.5),
                                    decoration: TextDecoration.underline),
                              )),
                          SizedBox(
                            height: MediaQuery.paddingOf(context).bottom + 15,
                          ),
                        ],
                      )),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

int calculateAge(DateTime birthDate) {
  final currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  if (birthDate.month > currentDate.month) {
    age--;
  } else if (birthDate.month == currentDate.month) {
    if (birthDate.day > currentDate.day) {
      age--;
    }
  }
  return age;
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
