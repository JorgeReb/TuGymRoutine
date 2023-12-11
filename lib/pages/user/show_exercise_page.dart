import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/services/user_service.dart';

class ShowExercisePage extends StatefulWidget {
  final Exercise exercise;
  
  const ShowExercisePage({super.key, required this.exercise});

  @override
  State<ShowExercisePage> createState() => _ShowExercisePageState();
}

class _ShowExercisePageState extends State<ShowExercisePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late Usuario user;
  bool isFavorite = false;
  bool isCurrentlyFavorite = false;

  @override
  void initState() {
    _cargarUsuarioDesdeBD();
    getImageFS();
    checkIfExerciseIsFavorite();
    super.initState();
  }

   Future<void> _cargarUsuarioDesdeBD() async {
    Usuario userDb = await UserService().getUserById(currentUser!.uid);
    setState(() {
      user = userDb;
    });
  }


  Future<String> getImageFS() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(widget.exercise.image!);
      final publicUrl = storageRef.getDownloadURL();

      return await publicUrl;
    } on FirebaseException catch (e) {
      if (e.message == "No object exists at the desired reference.") return 'Error';
      return 'Error';
    }
  }

   void checkIfExerciseIsFavorite() async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

    final userDoc = await userRef.get();

     
    setState(() {
      isCurrentlyFavorite = (userDoc['favorites_exercises'] as List).contains(widget.exercise.id);
    });
       
  }

  void toggleFavoriteStatus(String exerciseId) async{
    final userUid = user.id;

    final userRef = FirebaseFirestore.instance.collection('users').doc(userUid); 
  
    await userRef.update({
      'favorites_exercises': isCurrentlyFavorite
          ? FieldValue.arrayRemove([exerciseId])
          : FieldValue.arrayUnion([exerciseId]),
    });

    setState(() {
        isCurrentlyFavorite = !isCurrentlyFavorite;
    });

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
                    padding: EdgeInsets.only(top: 100),
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
                          Row(
                            children: [
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
                               Padding(
                                padding: const EdgeInsets.only(left: 260, top: 40),
                                child: IconButton(
                                  icon: Icon(
                                    isCurrentlyFavorite ? Icons.star :  Icons.star_border,
                                    color: Colors.yellow[600],
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    // Navegar a la página anterior al presionar el botón
                                    toggleFavoriteStatus(widget.exercise.id);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.exercise.name!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 30,
                              fontWeight: FontWeight.w200),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _ExerciseProperty(property: widget.exercise.description!),
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

