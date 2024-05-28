import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/profile/cubit/profile_cubit.dart';
import 'package:pulse_pro/shared/helpers/animated_number_picker.dart';
import 'package:pulse_pro/shared/helpers/enum_to_text.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';

class ProfileSettingPanel extends StatefulWidget {
  const ProfileSettingPanel({super.key});

  @override
  State<ProfileSettingPanel> createState() => _ProfileSettingPanelState();
}

class _ProfileSettingPanelState extends State<ProfileSettingPanel> {
  DateTime? _birthDate;
  Gender? _gender;
  int? _height;
  double? _weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 37, 28, 54),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              switch (state.status) {
                case ProfileStatus.editBirthDate:
                  return _editBirthDatePage();
                case ProfileStatus.editGender:
                  return _editGenderPage();
                case ProfileStatus.editHeight:
                  return _editHeightPage();
                case ProfileStatus.editWeight:
                  return _editWeightPage();
                default:
                  return const SizedBox();
              }
            },
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
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
                onPressed: () {
                  if (_birthDate != null) {
                    context.read<ProfileCubit>().updateValue('birthdate', _birthDate!.millisecondsSinceEpoch);
                  }
                  if (_gender != null) {
                    context.read<ProfileCubit>().updateValue('gender', _gender!.toString().split('.').last);
                  }
                  if (_height != null) {
                    context.read<ProfileCubit>().updateValue('height', _height);
                  }
                  if (_weight != null) {
                    context.read<ProfileCubit>().updateValue('weight', _weight);
                  }

                  context.read<ProfileCubit>().edit();
                },
                child: Text(
                  'Save & Close',
                  style: TextStyle(
                    color: Colors.deepPurple.shade100,
                    fontSize: 15,
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget _editBirthDatePage() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
            children: <TextSpan>[
              TextSpan(
                text: 'Edit your ',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 32,
                ),
              ),
              TextSpan(
                text: 'Birthdate.',
                style: TextStyle(
                  color: Colors.deepPurple.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.pulseProUser == null) return const SizedBox();

            return SizedBox(
                height: 250,
                child: ScrollWheelDatePicker(
                  onSelectedItemChanged: (value) => _birthDate = value,
                  listenAfterAnimation: false,
                  startDate: DateTime.now().add(const Duration(days: -(365 * 100))),
                  lastDate: DateTime.now(),
                  theme: CurveDatePickerTheme(
                    wheelPickerHeight: 200.0,
                    overlay: ScrollWheelDatePickerOverlay.highlight,
                    itemTextStyle: defaultItemTextStyle.copyWith(color: Colors.white),
                    overlayColor: Colors.deepPurple.shade300.withOpacity(0.5),
                    overAndUnderCenterOpacity: 0.3,
                  ),
                ));
          },
        ),
      ],
    );
  }

  Widget _editGenderPage() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
            children: <TextSpan>[
              TextSpan(
                text: 'Edit your ',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 32,
                ),
              ),
              TextSpan(
                text: 'Gender.',
                style: TextStyle(
                  color: Colors.deepPurple.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
                children: List.generate(
              Gender.values.length,
              (index) {
                final newGender = Gender.values[index];
                final name = enumToText(newGender.name);

                return Padding(
                  padding: EdgeInsets.only(bottom: newGender != Gender.values.lastOrNull ? 15 : 0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white.withAlpha(30),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.deepPurple.shade400,
                      disabledForegroundColor: Colors.white,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _gender == newGender
                        ? null
                        : () {
                            setState(() {
                              _gender = newGender;
                            });
                          },
                    child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 50,
                        child: Center(
                            child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ))),
                  ),
                );
              },
            )),
          ),
        )
      ],
    );
  }

  Widget _editHeightPage() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
            children: <TextSpan>[
              TextSpan(
                text: 'Edit your ',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 32,
                ),
              ),
              TextSpan(
                text: 'Height.',
                style: TextStyle(
                  color: Colors.deepPurple.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.transparent, Colors.white, Colors.white, Colors.white, Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state.pulseProUser == null) return const SizedBox();

              return AnimatedNumberPicker(
                value: _height ?? state.pulseProUser!.height,
                minValue: 100,
                maxValue: 250,
                step: 1,
                haptics: true,
                axis: Axis.horizontal,
                textStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
                selectedTextStyle: TextStyle(
                  fontSize: 25.0,
                  color: Colors.grey.shade100,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                ),
                onChanged: (value) => setState(() => _height = value),
              );
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'cm',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _editWeightPage() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
            children: <TextSpan>[
              TextSpan(
                text: 'Edit your ',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 32,
                ),
              ),
              TextSpan(
                text: 'weight.',
                style: TextStyle(
                  color: Colors.deepPurple.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: AnimatedWeightPicker(
            min: 30,
            max: 300,
            dialColor: Colors.deepPurple.shade200,
            selectedValueColor: Colors.deepPurple.shade500,
            suffixTextColor: Colors.deepPurple.shade300,
            majorIntervalColor: Colors.deepPurple.shade200,
            subIntervalColor: Colors.white,
            minorIntervalColor: Colors.white,
            subIntervalTextColor: Colors.white,
            majorIntervalTextColor: Colors.white,
            minorIntervalTextColor: Colors.white,
            squeeze: 4,
            dialHeight: 45,
            division: 0.5,
            selectedValueStyle: TextStyle(fontFamily: 'sansman', fontSize: 30, color: Colors.deepPurple.shade500),
            onChange: (newValue) {
              setState(() {
                _weight = double.parse(newValue);
              });
            },
          ),
        )
      ],
    );
  }
}
