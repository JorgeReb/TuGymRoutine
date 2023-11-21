import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:tu_gym_routine/models/exercise.dart';

class ExerciseService {
  final dio = Dio();

  CollectionReference collectionReferenceExercise = FirebaseFirestore.instance.collection('exercises'); //selecionamos la tabla de la bbdd

  getExercises() async {
    List<Exercise> exercises = [];
    QuerySnapshot queryExercise = await collectionReferenceExercise.get(); //obtenemos los registros que hay en esa coleccion

    for (var document in queryExercise.docs) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final Exercise exercise = Exercise.fromMap({'exerciseId': document.id, ...data});
      exercises.add(exercise);
    }
    return exercises;
  }

  addExercise(
    String name,
    String description,
    String type,
    String muscle,
    String image,
    String equipment,
    String difficulty,
    String objective
  ) async {
    try {
      final response = await dio.post('https://addexercise-ycxk3qq6za-uc.a.run.app', data: {
        "name": name,
        "description": description,
        "type": type,
        "muscle": muscle,
        "image": image,
        "equipment": equipment,
        "difficulty": difficulty,
        "objective": objective
      });
      return response.data;
    } catch (e) {
      return e;
    }
  }

  updateExercise(
    String exerciseId,
    String name,
    String description,
    String type,
    String muscle,
    String image,
    String equipment,
    String difficulty,
    String objective
  ) async {
    final response = await dio.post('https://updateexercise-ycxk3qq6za-uc.a.run.app', data: {
      "exerciseId": exerciseId,
      "name": name,
      "description": description,
      "type": type,
      "muscle": muscle,
      "image": image,
      "equipment": equipment,
      "difficulty": difficulty,
      "objective": objective
    });
    return response.data;
  }

  deleteExercise(String exerciseId) async {
    final response = await dio.post('https://deleteexercise-ycxk3qq6za-uc.a.run.app',data: {"exerciseId": exerciseId});
    return response.data;
  }
}
