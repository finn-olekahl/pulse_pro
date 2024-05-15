import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  bool isLoginPopupOpen = false;
  sdsabd() => context.read<LoginCubit>().showServiceActionSheet();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic));
  }

  InputDecoration inputFieldDecoration({required String hintText}) =>
      InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 3),
        ),
      );

  void toggleLoginPopup() {
    setState(() {
      isLoginPopupOpen = !isLoginPopupOpen;
      if (isLoginPopupOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: MediaQuery.viewPaddingOf(context).bottom,
                top: MediaQuery.viewPaddingOf(context).bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize:
                                24.0), // Set the default font size for all spans
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Pulse',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 37.5,
                            ),
                          ),
                          TextSpan(
                            text: ' to the Max,',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 37.5,
                            ),
                          ),
                          TextSpan(
                            text: '\nPerform like a ',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 37.5,
                            ),
                          ),
                          const TextSpan(
                            text: 'Pro',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 37.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment
                        .centerLeft, // Aligns the RichText widget to the left // Adds padding around the text
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey.shade400,
                        ), // Base style for all text
                        children: const <TextSpan>[
                          TextSpan(text: 'Get Ready!'),
                          TextSpan(
                            text:
                                '\nWelcome to the first AI assisted workout planner.',
                          ),
                          TextSpan(
                            text:
                                '\nDesigned to elevate your spirit and body.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black.withAlpha(30),
                          foregroundColor: Colors.white,
                          side: BorderSide(
                              color: Colors.grey.shade700, width: 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // 30 is the radius value
                          ),
                        ),
                        onPressed: toggleLoginPopup,
                        child: const Text('Login or Signup'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: const FaIcon(FontAwesomeIcons.google),
                              onPressed: () => context
                                  .read<LoginCubit>()
                                  .signInWithGoogle()),
                          IconButton(
                              icon: const FaIcon(FontAwesomeIcons.apple),
                              onPressed: () => context.read<LoginCubit>().signInWithApple())
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: isLoginPopupOpen ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: GestureDetector(
                onTap: () {
                  print("test");
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return FractionalTranslation(
                  translation: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          toggleLoginPopup();
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(color: Colors.transparent),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: IntrinsicHeight(
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(30),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Login or Signup",
                                            style: TextStyle(
                                              color: Colors.grey.shade300,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          SizedBox(
                                            height: 40,
                                            child: TextField(
                                              autocorrect: false,
                                              controller: emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration:
                                                  inputFieldDecoration(
                                                      hintText: "Email"),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            height: 40,
                                            child: TextField(
                                              autocorrect: false,
                                              controller: passwordController,
                                              keyboardType: TextInputType
                                                  .visiblePassword,
                                              obscureText: true,
                                              decoration:
                                                  inputFieldDecoration(
                                                      hintText: "Password"),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            height: 40,
                                            child: TextField(
                                              autocorrect: false,
                                              controller:
                                                  repeatPasswordController,
                                              keyboardType: TextInputType
                                                  .visiblePassword,
                                              obscureText: true,
                                              decoration:
                                                  inputFieldDecoration(
                                                      hintText:
                                                          "Repeat Password"),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          ButtonTheme(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                minimumSize: const Size(
                                                    double.infinity, 40),
                                                backgroundColor: Colors.black
                                                    .withAlpha(30),
                                                foregroundColor: Colors.white,
                                                side: BorderSide(
                                                    color:
                                                        Colors.grey.shade700,
                                                    width: 3),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30),
                                                ),
                                              ),
                                              onPressed: () => context
                                                  .read<LoginCubit>()
                                                  .signInOrSignUpWithEmailAndPassword(
                                                      email: emailController
                                                          .text,
                                                      password:
                                                          passwordController
                                                              .text),
                                              child: const Text(
                                                  'Login or Signup'),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
