import 'package:flutter/material.dart';

import 'package:tu_gym_routine/constants/constants.dart';

// ignore: must_be_immutable
class CustomAdminInputField extends StatelessWidget {
  final String label;
  final Icon icon;
  final bool isEnabled;

  final TextEditingController controller;
  String? Function(String? val)? validator;

  CustomAdminInputField({
      super.key,
      this.label = '',
      required this.icon,
      required this.validator,
      required this.controller, 
      required this.isEnabled
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: primaryColor,fontSize: 12),
      controller: controller,
      cursorColor: primaryColor,
      validator: validator,
      enabled: isEnabled,
      decoration: InputDecoration(
        isDense: true,
        errorStyle: TextStyle(color: Colors.redAccent.withOpacity(0.6)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.6))),
        suffixIcon: Padding(padding: const EdgeInsets.only(left: 10, top: 20), child: icon),
        labelText: label,
        labelStyle: const TextStyle(color: primaryColor, fontSize: 15),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1,color: primaryColor,)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1,color: primaryColor,)),
      ),
    );
  }
}