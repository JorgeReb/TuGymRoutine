import 'package:flutter/material.dart';

class NameLogo extends StatelessWidget {
  const NameLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 40, left: 40),
      child: Image.asset('assets/foto_nombre.png'),
    );
  }
}