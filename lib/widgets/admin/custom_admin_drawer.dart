import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/views/views.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';



class CustomAdminDrawer extends StatelessWidget {
  const CustomAdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        children: [
          const _Image(),
          const _AdminText(),
          Container(height: 20,color: primaryColor),
          SizedBox(
            child: BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              return Column(
                children: [
                  CustomListTile(
                    title: 'Lista de usuarios',
                    icon: Icons.account_circle_rounded,
                    onTap: () => BlocProvider.of<AdminBloc>(context).add(ChangeViewEvent(view: const ListUserView()))
                  ),
                  CustomListTile(
                    title: 'Lista de ejercicios',
                    icon: Icons.list,
                    onTap: () => context.read<AdminBloc>().add(ChangeViewEvent(view: const ListExerciseView()))
                  ),
                ],
              );
            },
          )),
          Expanded(child: Container(color: primaryColor)),
          const _BotonSalir()
        ]
      ),
    );
  }
}


class _AdminText extends StatelessWidget {
  const _AdminText();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      height: 60,
      width: double.infinity,
      child: const Text(
        'ADMIN',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      width: 350,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, bottom: 25),
        child: Image.asset('assets/foto_login.png'),
      ),
    );
  }
}

class _BotonSalir extends StatelessWidget {
  const _BotonSalir();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance;  
    return Container(
      height: 50,
      color: Colors.redAccent,
      child: ListTile(
        tileColor: primaryColor,
        onTap: () async{
          await user.signOut().then((value) {
            BlocProvider.of<AdminBloc>(context).state.view = const LogoView();
            Navigator.pushReplacementNamed(context, '/');
          });
        },
        title: const Text('Salir',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center
        ),
      ),
    );
  }
}
