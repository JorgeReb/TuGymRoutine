import 'package:flutter/material.dart';

const Color alertColor = Colors.redAccent;
const Icon alertIcon = Icon(Icons.warning_amber_rounded, color: alertColor);
const Text cancelText = Text("Volver",style: TextStyle(color: alertColor));

const Color succesColor = Colors.blueAccent;
const Icon successIcon = Icon(Icons.check_circle_outline,color: succesColor,);
const Text aceptText = Text("Aceptar",style: TextStyle(color: succesColor));

//Register page
const Text succesTextRegister = Text('Usted ha sido registrado correctamente en la aplicación.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);
const Text alertTextRegister = Text('Ha ocurrido un error al registrarse.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);
const Text weakPasswordText = Text('La contraseña es débil, pruebe de nuevo.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);
const Text isRegisterdText = Text('Este correo ya ha sido registrado anteriormente.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);

//Login page
const Text invalidPasswordText = Text('La contraseña introducida es incorrecta.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);
const Text invalidEmailText = Text('El correo introducido no corresponde con niguno existente.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);
const Text userDiabledText = Text('La cuenta ha sido desactivada temporalmente.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center);
