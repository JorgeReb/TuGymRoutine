import 'package:flutter/material.dart';

class FormLabelInput extends StatelessWidget {
  final String name;
  const FormLabelInput({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(name, textAlign: TextAlign.left, style: const TextStyle(fontSize: 12))
    );
  }
}