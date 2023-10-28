import 'package:flutter/material.dart';
import 'package:tu_gym_routine/widgets/admin_custom_list_tile.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';

import 'widgets.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        const _Image(),
        const _AdminText(),
        Container(
          height: 20,
          color: const Color.fromARGB(255, 34, 34, 34),
        ),
        SizedBox(
            child: Column(
          children: [
            AdminCustomListTile(
                title: 'Agregar usuarios',
                icon: Icons.add_reaction_rounded,
                onTap: () {}),
            AdminCustomListTile(
                title: 'Eliminar usuarios', icon: Icons.delete, onTap: () {Navigator.pushNamed(context, '/admin', arguments: {'page': 'delete'});}),
            AdminCustomListTile(
                title: 'Ver lista de usuarios',
                icon: Icons.account_circle_rounded,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/userlist');
                }),
            AdminCustomListTile(
                title: 'Agregar ejercicio', icon: Icons.check, onTap: () {}),
            AdminCustomListTile(
                title: 'Eliminar ejercicio', icon: Icons.cancel, onTap: () {}),
            AdminCustomListTile(
                title: 'Ver lista de ejercicios',
                icon: Icons.list,
                onTap: () {}),
          ],
        )),
        Expanded(
            child: Container(color: const Color.fromARGB(255, 34, 34, 34))),
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
    return Container(
      height: 50,
      color: Colors.redAccent,
      child: ListTile(
        tileColor: const Color.fromARGB(255, 34, 34, 34),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
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
