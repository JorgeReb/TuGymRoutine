import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/models/workout.dart';

class ExerciseService {
  final dio = Dio();

  CollectionReference collectionReferenceExercise = FirebaseFirestore.instance.collection('exercises'); //selecionamos la tabla de la bbdd

  getExercises() async {
    List<Exercise> exercises = [];
    QuerySnapshot queryExercise = await collectionReferenceExercise.get(); //obtenemos los registros que hay en esa coleccion

    for (var document in queryExercise.docs) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final Exercise exercise = Exercise.fromMap({'id': document.id, ...data});
      exercises.add(exercise);
    }
    return exercises;
  }

  
  getExercisesByIds(List<String> exercisesIds) async {

    QuerySnapshot queryExercise = await collectionReferenceExercise.where(FieldPath.documentId, whereIn: exercisesIds).get(); 

    final List<Exercise> exercises = [];

    for (var document in queryExercise.docs) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final Exercise exercise = Exercise.fromMap({'exerciseId': document.id, ...data});
      exercises.add(exercise);
    }
    return exercises;
  }

  getWorkouts() async{
    List<Workout> workouts = [];
    QuerySnapshot queryWorkout = await FirebaseFirestore.instance.collection('workouts').get(); 
     for (var document in queryWorkout.docs) {
      final Map<String, Object?>? data = document.data() as Map<String, Object?>? ;
      
      if(data != null){
        final Workout workout = Workout.fromMap({'workoutId': document.id, ...data});
        workouts.add(workout);
      }else{
        return null;
      }
    }
    return workouts;
  }


  getWorkoutsById(List<String> workoutId) async {

    QuerySnapshot queryExercise = await collectionReferenceExercise.where(FieldPath.documentId, whereIn: workoutId).get(); 

    final List<Workout> workouts = [];

    for (var document in queryExercise.docs) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final Workout workout = Workout.fromMap({'workoutId': document.id, ...data});
      workouts.add(workout);
    }
    return workouts;
  }
  addWorkout(Workout workout)async{
    try{
      final Map<String, dynamic> workoutConverted = workout.toMap();
      await FirebaseFirestore.instance.collection('workouts').doc().set(workoutConverted);

      return{"succes" : true};
    } catch(e) {
      return e;
    }
  }

  addHistoryUserWorkouts(history) async {
    try{
      await FirebaseFirestore.instance.collection('history_user_workouts').add(history);

      return{"succes" : true};
      
    } catch(e) {
      return e;
    }
  }

  getHistoryUserWorkoutsById(String id) async{ 
    try{
      QuerySnapshot<Map<String, dynamic>> querySnapshot= await FirebaseFirestore.instance.collection('history_user_workouts').where("user_id", isEqualTo: id).get(); 
        Map<String, dynamic> datos = {};
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
          datos[doc.id] = doc.data();
        }

        return datos;
    } catch(e) {
      return Error;
    }
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
