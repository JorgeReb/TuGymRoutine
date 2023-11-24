import 'package:flutter/material.dart';
import 'package:tu_gym_routine/blocs/theme/theme_colors.dart';

class CustomTheme {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final ThemeColors lightColors;
  final ThemeColors darkColors;

  CustomTheme({required this.lightTheme, required this.darkTheme, required this.lightColors, required this.darkColors});
}