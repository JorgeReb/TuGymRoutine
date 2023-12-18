import 'dart:convert';

import 'package:tu_gym_routine/models/exercise.dart';

class Workout {
  String? name;
  String? description;
  int? numberOfExercises = 0;
  Map<int, Exercise>? exercises = {};
  String? workoutId;
 
  Workout({
    this.name, 
    this.description, 
    this.numberOfExercises, 
    this.exercises, 
    this.workoutId, 
  });

  Workout copyWith({
    String? name,
    String? description,
    int? numberOfExercises,
    Map<int, Exercise>? exercises,
    String? workoutId
  }){
    return Workout(
      name: name ?? this.name, 
      description: description ?? this.description, 
      numberOfExercises: numberOfExercises ?? this.numberOfExercises, 
      exercises: exercises ?? this.exercises,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  factory Workout.fromJson(String str) => Workout.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Workout.fromMap(Map<String, dynamic> json) {  
    Map<int, Exercise> exerciseList = {};
    if (json['exercises'] != null) {
      json['exercises'].forEach((key,value){
        int index = int.parse(key);
        exerciseList[index] = Exercise.fromMap(value);
      });
    }

    return Workout(
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      numberOfExercises: json["number_of_exercises"] ?? 0,
      exercises: exerciseList,
      workoutId: json["workoutId"],
  );
  }


  Map<String,dynamic> exerciseMap = {};

  Map<String,dynamic> toMap() {

    for (int i = 1; i < exercises!.length+1; i++) {
       exerciseMap = {...exerciseMap,
        i.toString():{
          "id": exercises![i]!.id,
          "series": exercises![i]!.series,
          "repetitions": exercises![i]!.repetitions,
        }
      };
    }
   
    final workoutConverted = {
      "name": name,
      "description": description,
      "numberOfExercises": numberOfExercises,
      "exercises": exerciseMap,
      "workoutId": workoutId,
    };
    return workoutConverted;
  }
}