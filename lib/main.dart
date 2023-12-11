import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/blocs/exercise_admin/exercise_admin_bloc.dart';
import 'package:tu_gym_routine/blocs/routine/routine_bloc.dart';
import 'package:tu_gym_routine/blocs/theme/theme_bloc.dart';
import 'package:tu_gym_routine/blocs/user/user_bloc.dart';
import 'package:tu_gym_routine/blocs/user_admin/user_admin_bloc.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'firebase_options.dart';

import 'package:tu_gym_routine/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => AdminBloc()),
    BlocProvider(create: (_) => UserAdminBloc()),
    BlocProvider(create: (_) => ExerciseAdminBloc()),
    BlocProvider(create: (_) => UserBloc()),
    BlocProvider(create: (_) => ThemeBloc()),
    BlocProvider(create: (_) => RoutineBloc()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = {
    '/': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/home': (context) => const HomePage(),
    '/admin': (context) => const AdminPage(),
    '/user': (context) => UserPage(user: Usuario(id: '', name: '', email: '', weight: 0, height: 0)),
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            theme: themeState.themeData,
            title: 'TuGymRoutine',
            debugShowCheckedModeBanner: false,
            initialRoute: '/home',
            routes: routes,
          );
        },
      ),
    );
  }
}
