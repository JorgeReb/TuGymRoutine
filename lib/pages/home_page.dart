import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tu_gym_routine/blocs/user/user_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/services/user_service.dart';
import 'package:tu_gym_routine/widgets/user/custom_user_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Usuario? user;

  @override
  void initState() {
    super.initState();
    _cargarUsuarioDesdeBD();
  }

   Future<void> _cargarUsuarioDesdeBD() async {
    Usuario userDb = await UserService().getUserById(currentUser!.uid);
    setState(() {
      user = userDb;
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('TuGymRoutine',style: TextStyle(color: theme.colorScheme.secondary)),
        backgroundColor: theme.colorScheme.background,
        surfaceTintColor: theme.colorScheme.background,
        shadowColor: theme.colorScheme.background,
        iconTheme: IconThemeData(color:Theme.of(context).colorScheme.secondary),
        elevation: 10,
        actions: [
          FutureBuilder<Usuario>(
            future: UserService().getUserById(currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center();
              } else {
                user = snapshot.data;
                final userName = snapshot.data!.name;
                return Row(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(fontSize: 15, color: theme.colorScheme.secondary),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.account_circle_rounded, size: 30, color: theme.colorScheme.secondary),
                    ),
                  ],
                );
              }
            }
          ),
        ],
      ),
      drawer: user != null ? CustomUserDrawer(user: user!) : null,
      body: BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        userState.token = currentUser!.getIdTokenResult().toString();
        return userState.view!;
      },
    ),
    backgroundColor: primaryColor,
    );
  }
}
