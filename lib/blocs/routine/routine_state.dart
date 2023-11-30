part of 'routine_bloc.dart';

class RoutineState {
  bool? showInputName;
  bool? showExercises;
  bool? exercisesChoosen;
  
  String? routineName;
  String? exerciseName;
  int? series;
  int? repetitions;
  List? exercises = [];

  RoutineState({
    this.showInputName, 
    this.exercisesChoosen, 
    this.showExercises, 
    this.routineName,
    this.exerciseName,
    this.series,
    this.repetitions,
    this.exercises,
  });
}


