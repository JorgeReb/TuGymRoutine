import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tu_gym_routine/blocs/user/user_bloc.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/views/views.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';



class CustomUserDrawer extends StatelessWidget {
  final Usuario user;
  const CustomUserDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      width: 250,
      child: Column(
        children: [
          const _Image(),
          _UserText(user: user),
          SizedBox(
            child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return Column(
                children: [
                  CustomListTile(
                    title: 'Crear rutina',
                    icon: FontAwesomeIcons.notesMedical,
                    onTap: () => BlocProvider.of<UserBloc>(context).add(ChangeViewUserEvent(view: const CreateRoutineView()))
                  ),
                  CustomListTile(
                    title: 'Ver ejercicios',
                    icon: Icons.list,
                    onTap: () => BlocProvider.of<UserBloc>(context).add(ChangeViewUserEvent(view: const ExercisesView()))
                  ),
                  CustomListTile(
                    title: 'Entrenamientos',
                    icon: FontAwesomeIcons.dumbbell,
                    onTap: () => context.read<UserBloc>().add(ChangeViewUserEvent(view: const WorkoutsView()))
                  ),
                  CustomListTile(
                    title: 'Mis rutinas',
                    icon: Icons.calendar_today ,
                    onTap: () => context.read<UserBloc>().add(ChangeViewUserEvent(view: HistoryUserWorkouts(user: user)))
                  ),
                  CustomListTile(
                    title: 'Ejercicios favoritos',
                    icon: Icons.star_outlined ,
                    onTap: () => context.read<UserBloc>().add(ChangeViewUserEvent(view: FavoritesExercisesView(user:user)))
                  ),
                  CustomListTile(
                    title: 'Calendario',
                    icon: Icons.calendar_month ,
                    onTap: () => context.read<UserBloc>().add(ChangeViewUserEvent(view: const CalendarView()))
                  ),
                  CustomListTile(
                    title: 'Perfil',
                    icon: Icons.account_circle_rounded,
                    onTap: () => context.read<UserBloc>().add(ChangeViewUserEvent(view: ProfileView(user:user)))
                  ),
                  CustomListTile(
                    title: 'Ajustes',
                    icon: Icons.settings,
                    onTap: () => context.read<UserBloc>().add(ChangeViewUserEvent(view: const SettingsView()))
                  ),
                ],
              );
            },
          )),
          Expanded(child: Container(color: theme.colorScheme.background)),
          const _BotonSalir()
        ],
      ),
    );
  }
}

class _UserText extends StatelessWidget {
  final Usuario user;

  const _UserText({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      height: 60,
      width: double.infinity,
      child:  Text(
        user.name.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
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
      color: Theme.of(context).colorScheme.background,
      width: 350,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, bottom: 25),
        child: Image.asset('assets/foto_login.png'),
      )
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
        onTap: () async{
          await user.signOut().then((value) {
            BlocProvider.of<UserBloc>(context).state.view = const LogoView();
            Navigator.pushReplacementNamed(context, '/');
          });
        },
        title: const Text('Cerrar sesión',
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
