import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pulse_pro/features/profile/cubit/profile_cubit.dart';
import 'package:pulse_pro/features/profile/view/widgets/edit_data_button.dart';
import 'package:pulse_pro/features/profile/view/widgets/logout_slide.dart';
import 'package:pulse_pro/features/profile/view/widgets/profile_detail.dart';
import 'package:pulse_pro/features/profile/view/widgets/profile_page_header.dart';
import 'package:pulse_pro/features/profile/view/widgets/profile_settings_panel.dart';
import 'package:pulse_pro/shared/helpers/capitalize.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ProfileStatus.initial || state.status == ProfileStatus.loaded) return;
          if (state.status == ProfileStatus.edit) {
            _panelController.close();
            return;
          }
          _panelController.open();
        },
        builder: (context, state) {
          if (state.pulseProUser == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              const ProfilePageHeader(),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).width * (2 / 3 - 0.05) - 30),
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
                                  label: 'Name',
                                  value: state.pulseProUser!.name,
                                  onEdit: () => context.read<ProfileCubit>().editValue(ProfileStatus.editName)),
                              const SizedBox(
                                width: 10,
                              ),
                              ProfileDetail(
                                  label: 'Email',
                                  value: state.pulseProUser!.email,
                                  onEdit: () => context.read<ProfileCubit>().editValue(ProfileStatus.editEmail))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ProfileDetail(
                                label: 'Birthdate',
                                value: formatDate(state.pulseProUser!.birthDate),
                                onEdit: () => context.read<ProfileCubit>().editValue(ProfileStatus.editBirthDate),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ProfileDetail(
                                  label: 'Gender',
                                  value: capitalize(state.pulseProUser!.gender.toString().split('.').last),
                                  onEdit: () => context.read<ProfileCubit>().editValue(ProfileStatus.editGender))
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
                                  value: '${state.pulseProUser!.height} cm',
                                  onEdit: () => context.read<ProfileCubit>().editValue(ProfileStatus.editHeight)),
                              const SizedBox(
                                width: 10,
                              ),
                              ProfileDetail(
                                  label: 'Weight',
                                  value: '${state.pulseProUser!.weight} kg',
                                  onEdit: () => context.read<ProfileCubit>().editValue(ProfileStatus.editWeight))
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
                                    fontWeight: FontWeight.w400,
                                    color: Colors.deepPurple.shade200
                                        .withOpacity(0.5),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.deepPurple.shade200
                                        .withOpacity(0.5)),
                              )),
                          SizedBox(
                            height: MediaQuery.paddingOf(context).bottom + 15,
                          ),
                        ],
                      )),
                ),
              ),
              SlidingUpPanel(
                color: Colors.transparent,
                boxShadow: null,
                backdropTapClosesPanel: false,
                backdropEnabled: true,
                isDraggable: false,
                controller: _panelController,
                panelBuilder: (scrollController) => const ProfileSettingPanel(),
                defaultPanelState: PanelState.CLOSED,
                maxHeight: MediaQuery.sizeOf(context).height,
                padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).width * (2 / 3 - 0.05) - 30),
                minHeight: 0,
              )
            ],
          );
        },
      ),
    );
  }
}

String formatDate(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd.MM.yyyy');
  final String formatted = formatter.format(dateTime);
  return formatted;
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
