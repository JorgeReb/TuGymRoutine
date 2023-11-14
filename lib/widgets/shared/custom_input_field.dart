import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomInputField extends StatelessWidget {
  final String nombreCampo;
  final IconData icon;
  final bool isObscureText;
  final TextEditingController controller;
  String? Function(String? val)? validator;

  CustomInputField({
    super.key, 
    required this.nombreCampo,
    required this.icon,
    required this.isObscureText, 
    required this.controller,
    required this.validator
  });

  @override
  Widget build(BuildContext context) {
    
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      validator: validator,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.redAccent.withOpacity(0.6)),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.6))),
          border: const UnderlineInputBorder(),
          suffixIcon: Icon(icon, color: Colors.white),
          labelText: nombreCampo,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
            width: 2,
            color: Colors.white,
          ))),
    );
    
  }
   
   String validateName(String value) {
   String pattern = r'(^[a-zA-Z ]*$)';
   RegExp regExp =  RegExp(pattern);
   if (value.isEmpty) {
     return "El nombre es necesario";
   } else if (!regExp.hasMatch(value)) {
     return "El nombre debe de ser a-z y A-Z";
   }
   return '';
 }

 
 
}

