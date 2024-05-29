import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';
import 'package:pulse_pro/shared/helpers/animated_number_picker.dart';
import 'package:pulse_pro/shared/helpers/enum_to_text.dart';
import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:pulse_pro/shared/models/pulsepro_user.dart';
import 'package:pulse_pro/shared/models/sport_orientation.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key, this.continueSignup});
  final bool? continueSignup;

  @override
  OnboardingViewState createState() => OnboardingViewState();
}

class OnboardingViewState extends State<OnboardingView> {
  final TextEditingController nameController = TextEditingController();
  Gender? gender;
  DateTime? birthDate;
  double? weight;
  int? height;
  WorkoutGoal? workoutGoal;
  WorkoutIntensity? workoutIntensity;
  WorkoutExperience? workoutExperience;
  int? maxTimesPerWeek;
  int timePerDay = 60;
  List<Injury> injuries = [];
  List<MuscleGroup> muscleFocus = [];
  SportOrientation sportOrientation = SportOrientation.none;

  int currentPage = 0;

  bool isValidName(String name) {
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s\-]+$');

    return name.isNotEmpty && nameRegExp.hasMatch(name);
  }

  bool canContinue() {
    if (currentPage == 0) {
      return isValidName(nameController.text);
    }
    if (currentPage == 1) {
      return gender != null;
    }
    if (currentPage == 2) {
      return workoutGoal != null;
    }
    if (currentPage == 3) {
      return workoutExperience != null;
    }
    if (currentPage == 4) {
      return workoutIntensity != null;
    }
    if (currentPage == 5) {
      return maxTimesPerWeek != null;
    }
    if (currentPage == 6) {
      return true;
    }
    if (currentPage == 7) {
      return birthDate != null;
    }
    if (currentPage == 8) {
      return weight != null;
    }
    if (currentPage == 9) {
      return height != null;
    }
    if (currentPage == 10) {
      return true;
    }
    if (currentPage == 11) {
      return true;
    }
    if (currentPage == 12) {
      return true;
    }
    return false;
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  final PageController pageController = PageController();

  void goBack() {
    pageController.animateToPage(currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic);
    setState(() {
      currentPage--;
    });
  }

  void goForth() async {
    if (currentPage == pages().length - 1) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('name', nameController.text);
      await prefs.setString('gender', gender!.name);
      await prefs.setInt('birthDate', birthDate!.millisecondsSinceEpoch);
      await prefs.setDouble('weight', weight!);
      await prefs.setInt('height', height!);
      await prefs.setString('workoutGoal', workoutGoal!.name);
      await prefs.setString('workoutIntensity', workoutIntensity!.name);
      await prefs.setString('workoutExperience', workoutExperience!.name);
      await prefs.setInt('maxTimesPerWeek', maxTimesPerWeek!);
      await prefs.setInt('timePerDay', timePerDay);
      await prefs.setStringList(
          'injuries',
          injuries.map(
            (e) {
              return e.name;
            },
          ).toList());
      await prefs.setStringList(
          'muscleFocus',
          muscleFocus.map(
            (e) {
              return e.name;
            },
          ).toList());
      await prefs.setString('sportOrientation', sportOrientation.name);

      if (!mounted) return;
      if (widget.continueSignup == false) {
        return context.go('/login/createAccountLoading');
      }

      return context.read<LoginCubit>().finishOnboarding(
            context,
            name: nameController.text,
            gender: gender!,
            birthDate: birthDate!,
            weight: weight!,
            height: height!,
            workoutGoal: workoutGoal!,
            workoutIntensity: workoutIntensity!,
            workoutExperience: workoutExperience!,
            maxTimesPerWeek: maxTimesPerWeek!,
            timePerDay: timePerDay,
            injuries: injuries,
            muscleFocus: muscleFocus,
            sportOrientation: sportOrientation,
          );
    }
    pageController.animateToPage(currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic);
    setState(() {
      currentPage++;
    });
  }

  List<Widget> pages() {
    return [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Let\'s Get to Know Each ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Other.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tell us your name so we know what we can call you!',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              child: TextField(
                controller: nameController,
                onChanged: (value) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Tell us your name",
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white.withAlpha(30),
                ),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'What\'s your ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Gender?',
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
            Expanded(
              child: ClipRRect(
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
                        padding: EdgeInsets.only(
                            bottom:
                                newGender != Gender.values.lastOrNull ? 15 : 0),
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
                          onPressed: gender == newGender
                              ? null
                              : () {
                                  setState(() {
                                    gender = newGender;
                                    goForth();
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
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Your Fitness Journey Starts ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Here.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What is the primary goal, that you are aiming to achieve through your workouts?',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                      children: List.generate(
                    WorkoutGoal.values.length,
                    (index) {
                      final newWorkoutGoal = WorkoutGoal.values[index];
                      final name = enumToText(newWorkoutGoal.name);

                      return Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                newWorkoutGoal != WorkoutGoal.values.lastOrNull
                                    ? 15
                                    : 0),
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
                          onPressed: workoutGoal == newWorkoutGoal
                              ? null
                              : () {
                                  setState(() {
                                    workoutGoal = newWorkoutGoal;
                                    goForth();
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
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Its All About ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Experience.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What is your prior Workout Experience?',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                      children: List.generate(
                    WorkoutExperience.values.length,
                    (index) {
                      final newWorkoutExperience =
                          WorkoutExperience.values[index];
                      final name = enumToText(newWorkoutExperience.name);

                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: newWorkoutExperience !=
                                    WorkoutExperience.values.lastOrNull
                                ? 15
                                : 0),
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
                          onPressed: workoutExperience == newWorkoutExperience
                              ? null
                              : () {
                                  setState(() {
                                    workoutExperience = newWorkoutExperience;
                                    goForth();
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
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Intensity - You ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Decide.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'How much Intensity are you willing to put into your workout? Choose what covers your needs the best.',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                      children: List.generate(
                    WorkoutIntensity.values.length,
                    (index) {
                      final newWorkoutIntensity =
                          WorkoutIntensity.values[index];
                      final name = enumToText(newWorkoutIntensity.name);

                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: newWorkoutIntensity !=
                                    WorkoutIntensity.values.lastOrNull
                                ? 15
                                : 0),
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
                          onPressed: workoutIntensity == newWorkoutIntensity
                              ? null
                              : () {
                                  setState(() {
                                    workoutIntensity = newWorkoutIntensity;
                                    goForth();
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
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Let\'s Talk About ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Consistency.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'How many days per week are you willing to work out?',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                      children: List.generate(
                    7,
                    (index) {
                      int newMaxTimesPerWeek = index + 1;
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: newMaxTimesPerWeek != 7 ? 15 : 0),
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
                          onPressed: maxTimesPerWeek == newMaxTimesPerWeek
                              ? null
                              : () {
                                  setState(() {
                                    maxTimesPerWeek = newMaxTimesPerWeek;
                                    goForth();
                                  });
                                },
                          child: SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: 50,
                              child: Center(
                                  child: Text(
                                newMaxTimesPerWeek.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ))),
                        ),
                      );
                    },
                  )),
                ),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'It\'s Only a Matter of ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Time.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'How much time are you ready to invest into each workout?',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
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
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.white,
                    Colors.transparent
                  ],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              child: AnimatedNumberPicker(
                value: timePerDay,
                minValue: 15,
                maxValue: 180,
                step: 5,
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
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 3),
                ),
                onChanged: (value) => setState(() => timePerDay = value),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Minutes',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Age Is Just a Number - But ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Not for Us.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'You might be old, you might be young or anything inbetween. For creating a workout plan that meets your requirements, we need to know. And we can wish you a Happy Birthday!',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                height: 250,
                child: ScrollWheelDatePicker(
                  onSelectedItemChanged: (value) {
                    setState(() {
                      birthDate = value;
                    });
                  },
                  listenAfterAnimation: false,
                  startDate:
                      DateTime.now().add(const Duration(days: -(365 * 100))),
                  lastDate: DateTime.now(),
                  theme: CurveDatePickerTheme(
                    wheelPickerHeight: 200.0,
                    overlay: ScrollWheelDatePickerOverlay.highlight,
                    itemTextStyle:
                        defaultItemTextStyle.copyWith(color: Colors.white),
                    overlayColor: Colors.deepPurple.shade300.withOpacity(0.5),
                    overAndUnderCenterOpacity: 0.3,
                  ),
                )),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Is this too ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'personal?',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'We know it\'s a critical subject - but we still have to know your weight.',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
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
                selectedValueStyle: TextStyle(
                    fontFamily: 'sansman',
                    fontSize: 30,
                    color: Colors.deepPurple.shade500),
                onChange: (newValue) {
                  setState(() {
                    weight = double.parse(newValue);
                  });
                },
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'To The Sky and ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Beyond.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Damn... how high are you?!',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
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
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.white,
                    Colors.transparent
                  ],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              child: AnimatedNumberPicker(
                value: height ?? 175,
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
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 3),
                ),
                onChanged: (value) => setState(() => height = value),
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
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'The sky is (not) the ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Limit.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your health is everything we care about. If you have any injuried, disabled or painful body parts, please let us know. We will adapt the workout plan to your needs. Please select any problem areas that apply to you.',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                      children: List.generate(
                    Injury.values.length,
                    (index) {
                      final newInjury = Injury.values[index];
                      final name = enumToText(newInjury.name);

                      return Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                newInjury != Injury.values.lastOrNull ? 15 : 0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: injuries.contains(newInjury)
                                ? Colors.deepPurple.shade400
                                : Colors.white.withAlpha(30),
                            foregroundColor: Colors.white,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: injuries.contains(newInjury)
                              ? () {
                                  setState(() {
                                    injuries.remove(newInjury);
                                  });
                                }
                              : () {
                                  setState(() {
                                    injuries.add(newInjury);
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
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'To Each his own - Preference is ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Key.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'If you got any preferences for Muscles/Muscle Groups you want to prefer in the workouts? We\'ve got you covered!',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                      children: List.generate(
                    MuscleGroup.values.length,
                    (index) {
                      final newMuscleFocus = MuscleGroup.values[index];
                      final name = enumToText(newMuscleFocus.name);

                      return Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                newMuscleFocus != MuscleGroup.values.lastOrNull
                                    ? 15
                                    : 0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                muscleFocus.contains(newMuscleFocus)
                                    ? Colors.deepPurple.shade400
                                    : Colors.white.withAlpha(30),
                            foregroundColor: Colors.white,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: muscleFocus.contains(newMuscleFocus)
                              ? () {
                                  setState(() {
                                    muscleFocus.remove(newMuscleFocus);
                                  });
                                }
                              : () {
                                  setState(() {
                                    muscleFocus.add(newMuscleFocus);
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
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 24.0, fontFamily: 'sansman'),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Bring Your Performance to the Next ',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: 'Level.',
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'You might have a specific sport with you want to train for and boost your performance. Tell us.',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                      children: List.generate(
                    SportOrientation.values.length,
                    (index) {
                      final newSportOrientation =
                          SportOrientation.values[index];
                      final name = enumToText(newSportOrientation.name);

                      if (newSportOrientation == SportOrientation.none) {
                        return Container();
                      }

                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: newSportOrientation !=
                                    SportOrientation.values.lastOrNull
                                ? 15
                                : 0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                sportOrientation == newSportOrientation
                                    ? Colors.deepPurple.shade400
                                    : Colors.white.withAlpha(30),
                            foregroundColor: Colors.white,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: sportOrientation == newSportOrientation
                              ? () {
                                  setState(() {
                                    sportOrientation = SportOrientation.none;
                                  });
                                }
                              : () {
                                  setState(() {
                                    sportOrientation = newSportOrientation;
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
              ),
            )
          ],
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 10),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (widget.continueSignup == false) {
                          return context
                              .read<LoginCubit>()
                              .cancelOnboardingSignOut(context);
                        }
                        context.read<LoginCubit>().cancelOnboarding(context);
                      },
                      color: Colors.grey.shade500,
                      icon: const FaIcon(FontAwesomeIcons.anglesLeft)),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double barWidth = constraints.maxWidth;
                        int totalPages = pages().length;
                        double filledWidth =
                            barWidth * currentPage / (totalPages - 1);
                        return Stack(
                          children: [
                            Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color:
                                    Colors.deepPurple.shade100.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              height: 3,
                              width: filledWidth,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade100,
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: pages(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(30),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white.withAlpha(15),
                        disabledForegroundColor: Colors.white.withAlpha(60),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: currentPage == 0 ? null : goBack,
                      child: const SizedBox(
                          height: 50,
                          child: Center(
                              child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OutlinedButton(
                      clipBehavior: Clip.antiAlias,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.white.withAlpha(30),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white.withAlpha(15),
                        disabledForegroundColor: Colors.white.withAlpha(60),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: canContinue() ? () => goForth() : null,
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutQuad,
                          height: 50,
                          color: currentPage == pages().length - 1
                              ? Colors.deepPurple
                              : Colors.transparent,
                          child: Center(
                              child: Text(
                            currentPage == pages().length - 1
                                ? 'Finish'
                                : 'Continue',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ))),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
