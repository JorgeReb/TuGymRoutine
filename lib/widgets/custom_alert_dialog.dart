import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class CustomAlertDialog extends StatelessWidget {
  final Icon icon;
  final Text text;
  final TextButton textButton;
  final Color color;


  const CustomAlertDialog({super.key, required this.icon, required this.text, required this.textButton, required this.color});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds:300),
      child: AlertDialog(
        icon: icon,
        backgroundColor:  const Color.fromARGB(255, 37, 37, 37),
        content:   SizedBox(
            width: 50.0,
            height: 60.0,
            child:  Column(
              children: [
                text,
                const SizedBox(height: 10,),
                Divider(
                  color: color,
                )
              ],
            )
          ),
        buttonPadding: const EdgeInsets.all(0),
        contentPadding:
            const EdgeInsets.only(top: 12, left: 5, right: 5, bottom: 0),
            iconPadding: const EdgeInsets.only(bottom: 10, top: 12),
        actions: [
          Center(
            child: textButton
          ),
        ],
      ),
    );
  }
}
