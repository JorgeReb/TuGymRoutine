part of 'routine_bloc.dart';

class RoutineState {
  bool? showInputName;
  bool? showExercises;
  bool? exercisesChoosen;
  
  Workout? workout;

  RoutineState({
    this.showInputName, 
    this.exercisesChoosen, 
    this.showExercises, 
    this.workout
  });
}


