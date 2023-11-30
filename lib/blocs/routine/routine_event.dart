part of 'routine_bloc.dart';

class RoutineEvent {}

class ChangeEnabledInputsRoutine extends RoutineEvent{
  final bool isChooseExercise;
  final bool isShowExercise;
  final bool isExerciseChosen;
  final String routineName;
  final String exerciseName;
  final int series;
  final int repetitions;
  List? exercises;

  ChangeEnabledInputsRoutine({required this.isChooseExercise, required this.isShowExercise, required this.isExerciseChosen, required this.routineName, required this.exerciseName, required this.series, required this.repetitions, this.exercises});
}

class DisposeEventRoutine extends RoutineEvent{
  final bool isChooseExercise;
  final bool isShowExercise;
  final bool isExerciseChosen;
  DisposeEventRoutine({required this.isChooseExercise, required this.isShowExercise, required this.isExerciseChosen,});
}




