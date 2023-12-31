import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class CustomAlertDialog extends StatelessWidget {
  final Icon icon;
  final Text text;
  final Color color;
  final TextButton textButton;


  const CustomAlertDialog({super.key, required this.icon, required this.text, required this.color, required this.textButton});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds:300),
      child: AlertDialog(
        icon: icon,
        backgroundColor:  Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        content:   SizedBox(
            width: 50.0,
            height: 76.0,
            child:  Column(
              children: [
                text,
                const SizedBox(height: 20,),
                Divider(color: color)
              ],
            )
          ),
        buttonPadding: const EdgeInsets.all(0),
        contentPadding:
          const EdgeInsets.only(top: 1, left: 5, right: 5, bottom: 0),
          iconPadding: const EdgeInsets.only(bottom: 15, top: 15),
        actions: [
          Center(child: textButton),
        ],
      ),
    );
  }

  Future<void> showCustomDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        color: color,
        icon: icon,
        text: text,
        textButton: textButton,
      ),
    );
  }
}
