import 'dart:convert';

import 'package:tu_gym_routine/models/exercise.dart';

class Workout {
  String? name;
  String? description;
  int? numberOfExercises = 0;
  Map<int, Exercise>? exercises = {};
 
  Workout({
    this.name, 
    this.description, 
    this.numberOfExercises, 
    this.exercises, 
  });

  Workout copyWith({
    String? name,
    String? description,
    int? numberOfExercises,
    Map<int, Exercise>? exercises,
  }){
    return Workout(
      name: name ?? this.name, 
      description: description ?? this.description, 
      numberOfExercises: numberOfExercises ?? this.numberOfExercises, 
      exercises: exercises ?? this.exercises,
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
    };
    return workoutConverted;
  }
}