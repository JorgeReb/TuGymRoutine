import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/widgets/admin/admin_custom_list_tile.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';

import '../../views/views.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        const _Image(),
        const _AdminText(),
        Container(height: 20,color: const Color.fromARGB(255, 34, 34, 34)),
        SizedBox(
          child: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            return Column(
              children: [
                AdminCustomListTile(
                    title: 'Lista de usuarios',
                    icon: Icons.account_circle_rounded,
                    onTap: () {
                      BlocProvider.of<AdminBloc>(context).add(ChangeViewEvent(view: const ListUserView()));
                    }),
                AdminCustomListTile(
                    title: 'Lista de ejercicios',
                    icon: Icons.list,
                    onTap: () {
                      context.read<AdminBloc>().add(ChangeViewEvent(view: const ListExerciseView()));
                    }),
              ],
            );
          },
        )),
        Expanded(child: Container(color: const Color.fromARGB(255, 34, 34, 34))),
        const _BotonSalir()
      ]),
    );
  }
}


class _AdminText extends StatelessWidget {
  const _AdminText();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 34, 34, 34),
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
        color: const Color.fromARGB(255, 34, 34, 34),
        width: 350,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, bottom: 25),
          child: Image.asset(
            'assets/foto_login.png',
          ),
        ));
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
        tileColor: const Color.fromARGB(255, 34, 34, 34),
        onTap: () async{
          await user.signOut().then((value) => Navigator.pushReplacementNamed(context, '/'));
        },
        title: const Text('Salir',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center),
      ),
    );
  }
}
