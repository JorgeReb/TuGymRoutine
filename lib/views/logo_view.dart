import 'package:flutter/material.dart';

class LogoView extends StatelessWidget {
  const LogoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Image.asset(
          'assets/foto_nombre.png',
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      );
  }
}