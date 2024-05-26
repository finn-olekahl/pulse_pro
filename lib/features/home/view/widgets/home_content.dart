import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/home/view/widgets/muscle_highlight.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.985, end: 1.015).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).width * 0.6,
                child: Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 40, left: 20, right: 20)
                              .copyWith(bottom: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: const Color.fromARGB(255, 255, 183, 0)
                                .withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.all(45),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 80,
                                    blurStyle: BlurStyle.normal,
                                    color:
                                        const Color.fromARGB(255, 255, 119, 0)
                                            .withOpacity(0.4),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, 19),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: IntrinsicWidth(
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.amber.shade900,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Center(
                                child: Text(
                                  "Streak: ${(context.read<AppStateBloc>().state as AppStateLoggedIn).pulseProUser.streak}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "sansman",
                                    fontSize: 17.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: const Offset(0, -20),
                            child: Transform.scale(
                              scale: _animation.value,
                              child: Transform.rotate(
                                angle: 0.3,
                                child: Image.asset(
                                  "assets/images/flame.png",
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.55,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20, right: 20, top: 25 + 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3,
                              color:
                                  Colors.deepPurple.shade200.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.deepPurple.shade400
                                    .withOpacity(0.4)),
                            const BoxShadow(
                              blurStyle: BlurStyle.inner,
                              color: Color.fromARGB(255, 15, 8, 26),
                              spreadRadius: 10.0,
                              blurRadius: 40.0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(TextSpan(
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontFamily: "sansman",
                                    fontSize: 20),
                                children: const [
                                  TextSpan(
                                    text: "Todays ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: "Mission",
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ])),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.deepPurple.shade300
                                      .withOpacity(0.2)),
                              child: Row(
                                children: [
                                  Container(
                                      child: const MuscleHighlightWidget(
                                    muscleGroups: [
                                      MuscleGroup.abs,
                                      MuscleGroup.chest,
                                      MuscleGroup.calves
                                    ],
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    child: FaIcon(
                                      color: Colors.deepPurple.shade300,
                                      size: 20,
                                      FontAwesomeIcons.arrowRightLong,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
