import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 34, 34, 34);
const Color secundaryColor = Colors.white;

const Color alertColor = Colors.redAccent;
const Icon alertIcon = Icon(Icons.warning_amber_rounded, color: alertColor);
const Text cancelText = Text("Volver", style: TextStyle(color: alertColor));

const Color succesColor = Colors.blueAccent;
const Icon successIcon = Icon(Icons.check_circle_outline,color: succesColor,);
const Text aceptText = Text("Aceptar", style: TextStyle(color: succesColor));

//Register page
const Text succesTextRegister = Text('Usted ha sido registrado correctamente en la aplicación.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);
const Text alertTextRegister = Text('Ha ocurrido un error al registrarse.',style: TextStyle(color: Colors.white), textAlign: TextAlign.center);
const Text weakPasswordText = Text('La contraseña es débil, pruebe de nuevo.',style: TextStyle(color: Colors.white), textAlign: TextAlign.center);
const Text isRegisterdText = Text('Este correo ya ha sido registrado anteriormente.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);

//Login page
const Text invalidPasswordText = Text('La contraseña introducida es incorrecta.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);
const Text invalidEmailText = Text('Los datos introducidos no corresponden con ninguna cuenta.', style: TextStyle(color: Colors.white),textAlign: TextAlign.center);
const Text userDiabledText = Text('La cuenta ha sido desactivada temporalmente.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);

//User page
const Text askIsSure = Text('¿Estás seguro de querer eliminar este usuario?',style: TextStyle(color: Colors.white), textAlign: TextAlign.center);
const Text confirmDeleteText = Text("Eliminar", style: TextStyle(color: alertColor));

//Exercise page
const Text askIsSureExercise = Text('¿Estás seguro de querer eliminar este ejercicio?',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);

List<String> difficulties = <String>[
  "Principiante",
  "Fácil",
  "Intermedia",
  "Difícil",
  "Avanzada",
  "Intermedia a Avanzado"
];

List<String> equipments = <String>[
  "Mancuernas",
  "Barra",
  "Ninguno",
  "Barra fija",
  "Barras paralelas",
  "Goma elástica",
  "Esterilla",
  "Banco",
  "Máquina",
  "Barra con pesas, Mancuernas",
  "Ninguno, Barra con pesas"
];

List<String> types = <String>[
  "Resistencia",
  "Cardio",
  "Flexibilidad",
  "Fuerza",
];

List<String> muscles = <String>[
  "Bíceps",
  "Tríceps",
  "Gemelos",
  "Piernas",
  "Piernas, Glúteos",
  "Espalda",
  "Femoral",
  "Pecho",
  "Pecho, Tríceps",
  "Espalda baja",
  "Dorsales",
  "Trapecio",
  "Antebrazo",
  "Espalda, Bíceps",
  "Espalda, Glúteos",
  "Hombro lateral",
  "Hombros",
  "Hombro frontal",
  "Abdomen lateral",
  "Abdomen inferior",
  "Abdomen superior",
  "Abdominales",
  "Abdominales, Hombros",
  "Espalda baja, Piernas",
  "Pecho, Tríceps, Hombros",
  "Cuerpo completo"
];

List<String> objectives = <String>[
  "Mejora de flexibilidad",
  "Mejora de la flexibilidad y fortalecimiento de las piernas",
  "Mejora de la flexibilidad y fortalecimiento de la espalda baja",
  "Desarrollo de los músculos del bíceps",
  "Desarrollo de la fuerza en tríceps y pecho",
  "Fortalecimiento del abdomen",
  "Fortalecimiento del núcleo y mejora del equilibrio",
  "Coger fuerza en espalda y piernas",
  "Desarrollo de la fuerza en la espalda y bíceps",
  "Ganancia de fuerza y masa muscular en el pecho y tríceps",
  "Fortalecimiento de piernas",
  "Mejorar el equilibrio",
  "Desarrollo de la fuerza en hombros",
  "Quemar calorías y mejorar resistencia",
  "Fortalecimiento de espalda baja",
  "Desarrollo de la fuerza en la espalda y piernas",
  "Desarrollo de la fuerza en piernas y glúteos",
  "Quema de calorías y mejora de la resistencia",
  "Mejora de la flexibilidad y prevención de lesiones."
];
