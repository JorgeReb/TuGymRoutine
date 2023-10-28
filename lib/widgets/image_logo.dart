import 'package:flutter/material.dart';


// ignore: unused_element
class ImageLogo extends StatelessWidget {
  const ImageLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Image.asset(
        'assets/foto_login.png',
        height: 130,
        width: 130,
      ),
    );
  }
}
