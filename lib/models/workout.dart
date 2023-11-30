import 'dart:convert';

class Workout {
  final String workoutId;
  final String name;
  final int numberOfExercises;
  final Map<int, Map<String, dynamic>> exercise;
 

  Workout({
    required this.workoutId,
    required this.name, 
    required this.numberOfExercises, 
    required this.exercise, 

  });

  Workout copyWith({
    String? workoutId,
    String? name,
    int? numberOfExercises,
    Map<int, Map<String, dynamic>>? exercise,
  }){
    return Workout(
      workoutId: workoutId ?? this.workoutId,
      name: name ?? this.name, 
      numberOfExercises: numberOfExercises ?? this.numberOfExercises, 
      exercise: exercise ?? this.exercise,
    );
  }

  factory Workout.fromJson(String str) => Workout.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Workout.fromMap(Map<String, dynamic> json) {  
     Map<int, Map<String, dynamic>> exerciseList = {};

    if (json['exercises'] != null) {
      for (var key in json['exercises'].keys) {
        final int exerciseKey = int.tryParse(key) ?? 0;
        exerciseList[exerciseKey] = Map<String, dynamic>.from(json['exercises'][key] ?? {});
      }
    }

    return Workout(
      workoutId: json["workoutId"] ?? '',
      name: json["name"] ?? '',
      numberOfExercises: json["number_of_exercises"] ?? 0,
      exercise: exerciseList,
  );

  
  }

  Map<String, dynamic> toMap() => {
    "workoutId" : workoutId,
    "name": name,
    "numberOfExercises": numberOfExercises,
    "exercise": exercise,
  };
}