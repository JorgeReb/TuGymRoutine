import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/exercise.dart';

class ShowExercisePage extends StatelessWidget {
  final Exercise exercise;
  const ShowExercisePage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: FadeInDown(
        delay: const Duration(milliseconds: 200),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const _ExerciseImage(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:10),
                child: Text(exercise.name, style: const TextStyle(color: secundaryColor, fontSize: 30, fontWeight: FontWeight.w200), textAlign: TextAlign.center,),
              ),
              const SizedBox(height: 30),
              _ExerciseProperty(property: exercise.description),
              const SizedBox(height: 30),
              _ExerciseProperty(property: "Tipo de ejercicio:  ${exercise.type}"),
              const SizedBox(height: 30),
              _ExerciseProperty(property: "Músculos que intervienen:  ${exercise.muscle}"),
              const SizedBox(height: 30),
              _ExerciseProperty(property: "Equipamiento necesario:  ${exercise.equipment}"),
              const SizedBox(height: 30),
              _ExerciseProperty(property: "Dificultad del ejercicio:  ${exercise.difficulty}"),
              const SizedBox(height: 30),
              _ExerciseProperty(property: "Objetivos del ejercicio:  ${exercise.objective}"),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseProperty extends StatelessWidget {
  const _ExerciseProperty({
    required this.property,
  });

  final String property;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Text(property, style: const TextStyle(color: secundaryColor, fontSize: 20, fontWeight: FontWeight.w100), textAlign: TextAlign.center,),
    );
  }
}

class _ExerciseImage extends StatelessWidget {
  const _ExerciseImage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(boxShadow: [BoxShadow(blurRadius: 20)]),
          child: Image.asset(
            'assets/dominada.jpg',
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 40),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: secundaryColor,),
            onPressed: () {
              // Navegar a la página anterior al presionar el botón
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
