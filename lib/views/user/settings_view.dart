import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tu_gym_routine/blocs/theme/theme_bloc.dart';
import 'package:tu_gym_routine/pages/pages.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  FadeInDown(
      child:  Container(
        color: theme.colorScheme.background,
        child: Column(
          children: [
            _Tile(title: "Cambiar contraseña", icon: Icon(Icons.change_circle, color: theme.colorScheme.secondary), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()))),
            _Tile(title: "Cambiar tema", icon:  Icon(Icons.dark_mode, color: theme.colorScheme.secondary), onTap: () =>  BlocProvider.of<ThemeBloc>(context).add(ToggleThemeEvent())),
          ],
        ),
      ),
    );
  }
}
//no se com no me he desperrtado con tanto video
class _Tile extends StatefulWidget {
  final String title;
  final Icon icon;
  final VoidCallback  onTap;
  
  const _Tile({
    required this.title, required this.icon, required this.onTap
  });

  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> {
  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w200)),
      leading: Padding( padding: const EdgeInsets.only(left: 5),child: widget.icon),
      onTap: widget.onTap,
    );
    
  }
}