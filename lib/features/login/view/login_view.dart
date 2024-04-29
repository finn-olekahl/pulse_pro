import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/app/color_palette.dart';
import 'package:pulse_pro/features/login/cubit/login_cubit.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              MediaQuery.of(context).platformBrightness == Brightness.light ? columbiaBlue : oxfordBlue,
              MediaQuery.of(context).platformBrightness == Brightness.light ? columbiaBlue : oxfordBlue
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          )),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Placeholder(),
                  const Text(
                    "Pulse Pro",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton.icon(
                      onPressed: () => context.read<LoginCubit>().signInWithApple(),
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: SizedBox(
                          height: 20,
                          child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Apple_logo_white.svg/1724px-Apple_logo_white.svg.png',
                              fit: BoxFit.cover),
                        ),
                      ),
                      label: const Text('Login with Apple'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton.icon(
                      onPressed: () => context.read<LoginCubit>().signInWithGoogle(),
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: SizedBox(
                          height: 20,
                          child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                              fit: BoxFit.cover),
                        ),
                      ),
                      label: const Text('Login with Google'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Version beta-1.0",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
