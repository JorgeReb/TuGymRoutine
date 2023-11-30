import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/exercise.dart';

class ShowExercisePage extends StatefulWidget {
  final Exercise exercise;
  const ShowExercisePage({super.key, required this.exercise});

  @override
  State<ShowExercisePage> createState() => _ShowExercisePageState();
}

class _ShowExercisePageState extends State<ShowExercisePage> {
  Future<String> getImageFS() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(widget.exercise.image);
      final publicUrl = storageRef.getDownloadURL();

      return await publicUrl;
    } on FirebaseException catch (e) {
      if (e.message == "No object exists at the desired reference.") return 'Error';
      return 'Error';
    }
  }

  @override
  void initState() {
    getImageFS();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const imageBackgroundColor = primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FadeInDown(
        delay: const Duration(milliseconds: 200),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: getImageFS(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(child: CircularProgressIndicator()));
                } else {
                  final image = snapshot.data!;
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                              height: 250,
                              width: double.infinity,
                              decoration: const BoxDecoration(color: imageBackgroundColor,boxShadow: [BoxShadow(blurRadius: 15)]),
                              child: (image != "Error")
                                  ? CachedNetworkImage(
                                      imageUrl: image,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/foto_nombre.png',
                                      alignment: Alignment.center,
                                    )),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 40),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Navegar a la página anterior al presionar el botón
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.exercise.name,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 30,
                              fontWeight: FontWeight.w200),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _ExerciseProperty(property: widget.exercise.description),
                      const SizedBox(height: 30),
                      _ExerciseProperty(
                          property:
                              "Tipo de ejercicio:  ${widget.exercise.type}"),
                      const SizedBox(height: 30),
                      _ExerciseProperty(
                          property:
                              "Músculos que intervienen:  ${widget.exercise.muscle}"),
                      const SizedBox(height: 30),
                      _ExerciseProperty(
                          property:
                              "Equipamiento necesario:  ${widget.exercise.equipment}"),
                      const SizedBox(height: 30),
                      _ExerciseProperty(
                          property:
                              "Dificultad del ejercicio:  ${widget.exercise.difficulty}"),
                      const SizedBox(height: 30),
                      _ExerciseProperty(
                          property:
                              "Objetivos del ejercicio:  ${widget.exercise.objective}"),
                      const SizedBox(height: 30),
                    ],
                  );
                }
              }),
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
      child: Text(
        property,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 20,
            fontWeight: FontWeight.w100),
        textAlign: TextAlign.center,
      ),
    );
  }
}

