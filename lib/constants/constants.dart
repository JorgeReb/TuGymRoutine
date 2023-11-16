import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 34, 34, 34);
const Color secundaryColor = Colors.white;

const Color alertColor = Colors.redAccent;
const Icon alertIcon = Icon(Icons.warning_amber_rounded, color: alertColor);
const Text cancelText = Text("Volver", style: TextStyle(color: alertColor));

const Color succesColor = Colors.blueAccent;
const Icon successIcon = Icon(
  Icons.check_circle_outline,
  color: succesColor,
);
const Text aceptText = Text("Aceptar", style: TextStyle(color: succesColor));

//Register page
const Text succesTextRegister = Text(
    'Usted ha sido registrado correctamente en la aplicación.',
    style: TextStyle(color: Colors.white),
    textAlign: TextAlign.center);
const Text alertTextRegister = Text('Ha ocurrido un error al registrarse.',
    style: TextStyle(color: Colors.white), textAlign: TextAlign.center);
const Text weakPasswordText = Text('La contraseña es débil, pruebe de nuevo.',
    style: TextStyle(color: Colors.white), textAlign: TextAlign.center);
const Text isRegisterdText = Text(
    'Este correo ya ha sido registrado anteriormente.',
    style: TextStyle(color: Colors.white),
    textAlign: TextAlign.center);

//Login page
const Text invalidPasswordText = Text(
    'La contraseña introducida es incorrecta.',
    style: TextStyle(color: Colors.white),
    textAlign: TextAlign.center);
const Text invalidEmailText = Text(
    'Los datos introducidos no corresponden con ninguna cuenta.',
    style: TextStyle(color: Colors.white),
    textAlign: TextAlign.center);
const Text userDiabledText = Text(
    'La cuenta ha sido desactivada temporalmente.',
    style: TextStyle(color: Colors.white),
    textAlign: TextAlign.center);

//User page
const Text askIsSure = Text('¿Estás seguro de querer eliminar este usuario?',
    style: TextStyle(color: Colors.white), textAlign: TextAlign.center);
const Text confirmDeleteText =
    Text("Eliminar", style: TextStyle(color: alertColor));

//Exercise page
const Text askIsSureExercise = Text(
    '¿Estás seguro de querer eliminar este ejercicio?',
    style: TextStyle(color: Colors.white),
    textAlign: TextAlign.center);

List<String> difficulties = <String>[
  "Principiante",
  "Fácil",
  "Intermedio",
  "Difícil",
  "Avanzado"
];

List<String> equipments = <String>[
  "Mancuernas",
  "Barra",
  "Ninguno",
  "Barra fija",
  "Barras paralelas",
  "Goma elástica",
  "Esterilla",
  "Banco"
];

List<String> types = <String>[
  "Resistencia",
  "Cardio",
  "Flexibilidad",
  "Fuerza",
];

List<String> muscles = <String>[
  "Bícpes",
  "Tríceps",
  "Gemelo",
  "Pierna",
  "Pierna y glúteos",
  "Espalda",
  "Femoral",
  "Pecho",
  "Pecho y tríceps",
  "Espalda baja",
  "Dorsales",
  "Trapecio",
  "Antebrazo",
  "Bíceps y espalda",
  "Hombro lateral",
  "Hombro",
  "Hombro frontal",
  "Abdomen lateral",
  "Abdomen inferior",
  "Abdomen superior",
];

List<String> objectives = <String>[
  "Mejora de flexibilidad",
  "Desarrollo del bíceps",
  "Coger fuerza en tríceps y pecho",
  "Fortalecimiento del abdomen",
  "Coger fuerza en espalda y piernas",
  "Coger fuerza en espalda y bíceps",
  "Coger fuerza en piernas y glúteos",
  "Ganar fuerza y masa muscular en pecho y tríceps ",
  "Fortalecimiento de piernas",
  "Mejorar el equilibrio",
  "Coger fuerza en los hombros",
  "Quemar calorías y mejorar resistencia",
  "Fortalecimiento de espalda baja",
];
