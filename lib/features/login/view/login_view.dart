import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (_, current) => current.status == LoginStatus.showServiceActionSheet,
      listener: (context, state) {
        showCupertinoModalPopup(
            context: context,
            builder: (_) => CupertinoActionSheet(
              title: const Text('Choose a service'),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () => context.read<LoginCubit>().signInWithGoogle(),
                  child: const Text('Google'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () => context.read<LoginCubit>().signInWithApple(),
                  child: const Text('Apple'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => context.pop(),
                child: const Text('Cancel'),
              ),
            ));
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
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
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 24.0), // Set the default font size for all spans
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Pulse',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 37.5)),
                              TextSpan(
                                  text: ' to the Max,', style: TextStyle(color: Colors.grey.shade300, fontSize: 37.5)),
                              TextSpan(
                                  text: '\nPerform like a ',
                                  style: TextStyle(color: Colors.grey.shade300, fontSize: 37.5)),
                              const TextSpan(
                                  text: 'Pro',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 37.5)),
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
                            style: TextStyle(fontSize: 18.0, color: Colors.grey.shade400), // Base style for all text
                            children: const <TextSpan>[
                              TextSpan(text: 'Get Ready!'),
                              TextSpan(text: '\nWelcome to the first AI fitness app.'),
                              TextSpan(text: '\nDesigned to elevate your spirit and body.'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 170,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30), // 30 is the radius value
                                ),
                              ),
                              onPressed: () => context.read<LoginCubit>().showServiceActionSheet(),
                              child: const Text('Login with service'),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 50,
                            width: 170,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.black.withAlpha(30),
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey.shade700, width: 3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30), // 30 is the radius value
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Login with Email'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
