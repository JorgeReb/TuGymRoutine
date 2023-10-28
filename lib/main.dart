import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:tu_gym_routine/pages/admin/user_list_page.dart';
import 'firebase_options.dart';

import 'package:tu_gym_routine/pages/pages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = {
    '/': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/home': (context) => const HomePage(),
    '/admin' : (context) => const AdminPage(),
    '/userlist' : (context) => const UserListPage()
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
