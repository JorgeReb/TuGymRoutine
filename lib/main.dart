import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/blocs/user_admin/user_admin_bloc.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'firebase_options.dart';

import 'package:tu_gym_routine/pages/pages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AdminBloc()), 
        BlocProvider(create: (_) => UserAdminBloc()), 
      ], 
      child: MyApp()));
    
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = {
    '/': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/home': (context) => const HomePage(),
    '/admin' : (context) =>  const AdminPage(),
    '/user' : (context) =>  UserPage(user: Usuario(id: '', name: '', email: '')),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuGymRoutine',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
    );
  }
}
