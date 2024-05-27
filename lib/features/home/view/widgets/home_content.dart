import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/home/cubit/home_cubit.dart';
import 'package:pulse_pro/features/home/view/widgets/muscle_indicator.dart';
import 'package:pulse_pro/shared/models/muscle_group.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.viewPaddingOf(context).top,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        border: Border.all(
                            strokeAlign: BorderSide.strokeAlignOutside,
                            width: 2,
                            color:
                                Colors.deepPurple.shade300.withOpacity(0.15)),
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                  style: TextStyle(
                                      fontFamily: 'sansman',
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 22.5),
                                  children: [
                                    TextSpan(
                                      text: "Todays ",
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade100),
                                    ),
                                    const TextSpan(
                                      text: "Workout",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ])),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:
                                  Colors.deepPurple.shade300.withOpacity(0.1)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Text(
                                          "Chest, Triceps & Calves",
                                          style: TextStyle(
                                              fontSize: 27,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  Colors.deepPurple.shade100),
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: MuscleIndicator(
                                    silhouetteColor: Colors.deepPurple.shade300
                                        .withOpacity(0.3),
                                    muscleBaseColor: Colors.deepPurple.shade300
                                        .withOpacity(0.15),
                                    muscleHighlightColor: Colors
                                        .deepPurple.shade300
                                        .withOpacity(1),
                                    muscleGroups: const [MuscleGroup.legs],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade400,
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.transparent.withOpacity(0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            context.read<HomeCubit>().dockController.jumpTo(2);
                          },
                          child: const SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                'Start Workout',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                              ))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.paddingOf(context).bottom + 20,
            ),
          ],
        ),
      ),
    );
  }
}
