import 'package:bloc/bloc.dart';


part 'routine_event.dart';
part 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  RoutineBloc() : super(RoutineState(showInputName: true, exercisesChoosen: false, showExercises: false, routineName: '', exercises: [])) {
    on<ChangeEnabledInputsRoutine>((event, emit) {
      emit(RoutineState(
        showInputName: event.isChooseExercise, 
        exercisesChoosen: event.isExerciseChosen, 
        showExercises: event.isShowExercise, 
        routineName: event.routineName, 
        exerciseName: event.exerciseName, 
        series: event.series, 
        repetitions: event.repetitions,
        exercises: event.exercises
      ));
    });

    on<DisposeEventRoutine>((event, emit) {
      emit(RoutineState(showInputName: true, exercisesChoosen: false, showExercises: false, routineName: ''));
    });
  }
}
