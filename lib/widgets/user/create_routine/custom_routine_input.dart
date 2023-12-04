import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CustomRoutineInput extends StatelessWidget {
  final String nombreCampo;
  final IconData icon;
  final bool isObscureText;
  final TextEditingController controller;
  String? Function(String? val)? validator;

  CustomRoutineInput({
    super.key,
    required this.nombreCampo,
    required this.icon,
    required this.isObscureText,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscureText,
      cursorColor: Theme.of(context).colorScheme.secondary,
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent.withOpacity(0.6)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.6))),
        suffixIcon: Icon(icon,color: Theme.of(context).colorScheme.secondary, size: 20),
        labelText: nombreCampo,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.secondary)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.secondary)),
      ),
    );
  }
}
