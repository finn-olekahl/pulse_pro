import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/features/trainings_plan/cubit/trainings_plan_cubit.dart';

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
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).width * 0.7 - 40,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(40).copyWith(bottom: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color:
                              Color.fromARGB(255, 255, 183, 0).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 80,
                                  blurStyle: BlurStyle.normal,
                                  color: Color.fromARGB(255, 255, 119, 0)
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
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Center(
                              child: Text(
                                "Streak: ${(context.read<AppStateBloc>().state as AppStateLoggedIn).pulseProUser.streak}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "sansman",
                                  fontSize: 25,
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
                          offset: const Offset(0, -25),
                          child: Transform.scale(
                            scale: _animation.value,
                            child: Transform.rotate(
                              angle: 0.3,
                              child: Image.asset(
                                "assets/images/flame.png",
                                width: MediaQuery.sizeOf(context).width * 0.55,
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
          ],
        ),
      ),
    );
  }
}
