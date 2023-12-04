part of 'routine_bloc.dart';

class RoutineEvent {}

class ChangeEnabledInputsRoutine extends RoutineEvent{
  final bool isChooseExercise;
  final bool isShowExercise;
  final bool isExerciseChosen;

  ChangeEnabledInputsRoutine({required this.isChooseExercise, required this.isShowExercise, required this.isExerciseChosen});
}

class DisposeEventRoutine extends RoutineEvent{
  final bool isChooseExercise;
  final bool isShowExercise;
  final bool isExerciseChosen;
  DisposeEventRoutine({required this.isChooseExercise, required this.isShowExercise, required this.isExerciseChosen,});
}




