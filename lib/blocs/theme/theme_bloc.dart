import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/blocs/theme/custom_theme.dart';
import 'package:tu_gym_routine/blocs/theme/theme_colors.dart';
import 'package:tu_gym_routine/constants/constants.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(_initialCustomTheme())) {
    on<ToggleThemeEvent>((event, emit) {
      emit(ThemeState(
        state.themeData.brightness == Brightness.dark
            ? ThemeData.light().copyWith(
                colorScheme: ColorScheme?.fromSwatch().copyWith(
                    secondary: primaryColor,
                    background: secondaryColor,
                    brightness: Brightness.light),
              )
            : ThemeData.dark().copyWith(
                colorScheme: ColorScheme?.fromSwatch().copyWith(
                    secondary: secondaryColor,
                    background: primaryColor,
                    brightness: Brightness.dark)),
      ));
    });
  }
  static ThemeData _initialCustomTheme() {
    // Aquí defines tu tema personalizado inicial
    return ThemeData(
        colorScheme: ColorScheme?.fromSwatch().copyWith(
            secondary: secondaryColor,
            background: primaryColor,
            brightness: Brightness.dark)
        // Otros atributos según sea necesario
        );
  }
}
