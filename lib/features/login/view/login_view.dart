import 'dart:math';
import 'dart:ui';

import 'package:curved_gradient/curved_gradient.dart';
import 'package:flutter/gestures.dart';
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

  late AnimationController loginPopupAnimationController;
  late Animation<double> loginPopupAnimation;

  final PageController pageViewController = PageController();
  int currentPageIndex = 0;

  bool isLoginPopupOpen = false;

  @override
  void initState() {
    super.initState();

    loginPopupAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    loginPopupAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
            parent: loginPopupAnimationController,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic));
  }

  InputDecoration inputFieldDecoration({required String hintText}) =>
      InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 3),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 3),
        ),
      );

  void toggleLoginPopup() {
    setState(() {
      isLoginPopupOpen = !isLoginPopupOpen;
      if (isLoginPopupOpen) {
        loginPopupAnimationController.forward();
      } else {
        loginPopupAnimationController.reverse();
      }
    });
  }

  Widget buildPageIndicator(int pageCount, int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 3,
          width: (MediaQuery.of(context).size.width - 60) / pageCount - 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<LoginCubit>().state.status ==
            LoginStatus.postOnboarding &&
        !isLoginPopupOpen) {
      toggleLoginPopup();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            color: Colors.grey.shade800,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (rect) {
              return CurvedGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                      granularity: 10,
                      curveGenerator: (x) => pow(x, 2).toDouble())
                  .createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: currentPageIndex == 0 ? 1 : 0,
              curve: Curves.easeInOut,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.55,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.saturation),
                  child: Image.asset(
                    'assets/images/login_slide1.jpg',
                    gaplessPlayback: true,
                    isAntiAlias: true,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (rect) {
              return CurvedGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                      granularity: 10,
                      curveGenerator: (x) => pow(x, 2).toDouble())
                  .createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: currentPageIndex == 1 ? 1 : 0,
              curve: Curves.easeInOut,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.55,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.saturation),
                  child: Image.asset(
                    'assets/images/login_slide2.jpg',
                    gaplessPlayback: true,
                    isAntiAlias: true,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (rect) {
              return CurvedGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                      granularity: 10,
                      curveGenerator: (x) => pow(x, 2).toDouble())
                  .createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: currentPageIndex == 2 ? 1 : 0,
              curve: Curves.easeInOut,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.55,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.saturation),
                  child: Image.asset(
                    'assets/images/login_slide3.jpg',
                    gaplessPlayback: true,
                    isAntiAlias: true,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.viewPaddingOf(context).top + 10, left: 20),
              child: Image.asset(
                'assets/images/app_logo_white.png',
                gaplessPlayback: true,
                isAntiAlias: true,
                width: MediaQuery.sizeOf(context).width * 0.1,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (context.read<LoginCubit>().state.status ==
              LoginStatus.preOnboarding)
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewPaddingOf(context).bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: PageView(
                        dragStartBehavior: DragStartBehavior.down,
                        physics: const ClampingScrollPhysics(),
                        controller: pageViewController,
                        onPageChanged: (index) {
                          setState(() {
                            currentPageIndex = index;
                          });
                        },
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text.rich(
                                        TextSpan(
                                          style: const TextStyle(
                                              fontSize: 24.0,
                                              fontFamily: 'sansman'),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Pulse',
                                              style: TextStyle(
                                                color:
                                                    Colors.deepPurple.shade300,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 32,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' up,',
                                              style: TextStyle(
                                                color: Colors.grey.shade300,
                                                fontSize: 32,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\nPerform like a ',
                                              style: TextStyle(
                                                color: Colors.grey.shade300,
                                                fontSize: 32,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Pro',
                                              style: TextStyle(
                                                color:
                                                    Colors.deepPurple.shade300,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 32,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text.rich(
                                        TextSpan(
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.grey.shade400,
                                          ),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text.rich(
                                    TextSpan(
                                      style: const TextStyle(
                                          fontSize: 24.0,
                                          fontFamily: 'sansman'),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Workouts, Tailored to ',
                                          style: TextStyle(
                                            color: Colors.grey.shade300,
                                            fontSize: 32,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'your Needs',
                                          style: TextStyle(
                                            color: Colors.deepPurple.shade300,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey.shade400,
                                      ),
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: 'It doesn\'t get simpler.'),
                                        TextSpan(
                                          text:
                                              '\nGenerate Workout Plans based on your personal needs with the help of Artifical Intelligence',
                                        ),
                                        TextSpan(
                                          text:
                                              '\nBring your workouts to the next level!',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text.rich(
                                    TextSpan(
                                      style: const TextStyle(
                                          fontSize: 24.0,
                                          fontFamily: 'sansman'),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Its just ',
                                          style: TextStyle(
                                            color: Colors.grey.shade300,
                                            fontSize: 32,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'easy ',
                                          style: TextStyle(
                                            color: Colors.deepPurple.shade300,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'to use!',
                                          style: TextStyle(
                                            color: Colors.grey.shade300,
                                            fontSize: 32,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey.shade400,
                                      ),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text:
                                              'All exercises are come along with detailed explanations and easy-to-understand videos.',
                                        ),
                                        TextSpan(
                                          text:
                                              '\nNever struggle with doing your workouts correctly EVER again!',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildPageIndicator(3, currentPageIndex),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade400,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              context
                                  .read<LoginCubit>()
                                  .startOnboarding(context);
                            },
                            child: SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child:
                                    const Center(child: Text('Get Started'))),
                          ),
                          OutlinedButton(
                            key: const Key(
                                'loginButton'), // Schlüssel hinzugefügt
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.black.withAlpha(30),
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: toggleLoginPopup,
                            child: SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: const Center(child: Text('Login'))),
                          ),
                        ],
                      ),
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
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          AnimatedBuilder(
              animation: loginPopupAnimation,
              builder: (context, child) {
                return FractionalTranslation(
                  translation: Offset(0, loginPopupAnimation.value),
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
                        onTap: context.read<LoginCubit>().state.status ==
                                LoginStatus.preOnboarding
                            ? () {
                                toggleLoginPopup();
                                FocusScope.of(context).unfocus();
                              }
                            : null,
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
                                  filter:
                                      ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(30),
                                        child: Column(
                                          children: [
                                            Text(
                                              context
                                                          .read<LoginCubit>()
                                                          .state
                                                          .status ==
                                                      LoginStatus.preOnboarding
                                                  ? "Login"
                                                  : "Signup",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.75),
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
                                                style: const TextStyle(
                                                    color: Colors.white),
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
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                obscureText: true,
                                                decoration:
                                                    inputFieldDecoration(
                                                        hintText: "Password"),
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            if (context
                                                    .read<LoginCubit>()
                                                    .state
                                                    .status ==
                                                LoginStatus.postOnboarding)
                                              SizedBox(
                                                height: 40,
                                                child: TextField(
                                                  autocorrect: false,
                                                  controller:
                                                      repeatPasswordController,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText: true,
                                                  decoration:
                                                      inputFieldDecoration(
                                                          hintText:
                                                              "Repeat Password"),
                                                ),
                                              ),
                                            if (context
                                                    .read<LoginCubit>()
                                                    .state
                                                    .status ==
                                                LoginStatus.postOnboarding)
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
                                                      color: Colors
                                                          .deepPurple.shade300,
                                                      width: 3),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                ),
                                                onPressed: context
                                                            .read<LoginCubit>()
                                                            .state
                                                            .status ==
                                                        LoginStatus
                                                            .preOnboarding
                                                    ? () {
                                                        context
                                                            .read<LoginCubit>()
                                                            .signInWithEmailAndPassword(
                                                                email:
                                                                    emailController
                                                                        .text,
                                                                password:
                                                                    passwordController
                                                                        .text)
                                                            .then((value) {
                                                          if (value) {
                                                            context.push(
                                                                "/login/createAccountLoading");
                                                          }
                                                        });
                                                      }
                                                    : () {
                                                        context
                                                            .read<LoginCubit>()
                                                            .signUpWithEmailAndPassword(
                                                                email:
                                                                    emailController
                                                                        .text,
                                                                password:
                                                                    passwordController
                                                                        .text);
                                                      },
                                                child: Text(context
                                                            .read<LoginCubit>()
                                                            .state
                                                            .status ==
                                                        LoginStatus
                                                            .preOnboarding
                                                    ? "Login"
                                                    : "Signup"),
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            const Row(children: <Widget>[
                                              Expanded(child: Divider()),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  "OR",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Divider(
                                                color: Colors.grey,
                                              )),
                                            ]),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    icon: const FaIcon(
                                                        color: Colors.grey,
                                                        FontAwesomeIcons
                                                            .google),
                                                    onPressed: () => context
                                                        .read<LoginCubit>()
                                                        .signInWithGoogle()),
                                                IconButton(
                                                    icon: const FaIcon(
                                                        color: Colors.grey,
                                                        FontAwesomeIcons.apple),
                                                    onPressed: () => context
                                                        .read<LoginCubit>()
                                                        .signInWithApple())
                                              ],
                                            ),
                                            if (context
                                                    .read<LoginCubit>()
                                                    .state
                                                    .gender !=
                                                null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: ButtonTheme(
                                                  child: OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      minimumSize: const Size(
                                                          double.infinity, 40),
                                                      backgroundColor: Colors
                                                          .black
                                                          .withAlpha(30),
                                                      foregroundColor:
                                                          Colors.white,
                                                      side: BorderSide(
                                                          color: Colors
                                                              .grey.shade700,
                                                          width: 3),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                    ),
                                                    onPressed: context
                                                                .read<
                                                                    LoginCubit>()
                                                                .state
                                                                .status ==
                                                            LoginStatus
                                                                .postOnboarding
                                                        ? () {
                                                            setState(() {
                                                              context
                                                                  .read<
                                                                      LoginCubit>()
                                                                  .cancelOnboarding(
                                                                      context);
                                                            });
                                                          }
                                                        : () {
                                                            setState(() {
                                                              context
                                                                  .read<
                                                                      LoginCubit>()
                                                                  .continueOnboarding();
                                                            });
                                                          },
                                                    child: Text(context
                                                                .read<
                                                                    LoginCubit>()
                                                                .state
                                                                .status ==
                                                            LoginStatus
                                                                .postOnboarding
                                                        ? "Login instead"
                                                        : "Signup instead"),
                                                  ),
                                                ),
                                              ),
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
