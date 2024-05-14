import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/app/app_router.dart';
import 'package:pulse_pro/app/color_palette.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/repositories/authencitation_repository.dart';
import 'package:pulse_pro/repositories/exercise_repository.dart';
import 'package:pulse_pro/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (_) => AuthenticationRepository(),
      ),
      RepositoryProvider(
        create: (_) => UserRepository(),
      ),
      RepositoryProvider(create: (_) => ExerciseRepository())
    ],
    child: BlocProvider(
      lazy: false,
      create: (context) => AppStateBloc(userRepository: context.read<UserRepository>()),
      child: const PulseProApp(),
    ),
  ));
}

class PulseProApp extends StatelessWidget {
  static final storageUrl = 'gs://${FirebaseStorage.instance.app.options.storageBucket}';

  const PulseProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PulsePro',
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: sapphire, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: oxfordBlue, brightness: Brightness.dark),
      routerConfig: AppRouter(context).router,
    );
  }
}
