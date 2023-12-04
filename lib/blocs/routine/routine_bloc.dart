import 'package:bloc/bloc.dart';
import 'package:tu_gym_routine/models/workout.dart';


part 'routine_event.dart';
part 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  RoutineBloc() : super(RoutineState(showInputName: true, exercisesChoosen: false, showExercises: false, workout: Workout(exercises: {}, numberOfExercises: 0))) {
    on<ChangeEnabledInputsRoutine>((event, emit) {
      emit(RoutineState(
        showInputName: event.isChooseExercise, 
        exercisesChoosen: event.isExerciseChosen, 
        showExercises: event.isShowExercise, 
        workout: state.workout
      ));
    });

    on<DisposeEventRoutine>((event, emit) {
      emit(RoutineState(showInputName: true, exercisesChoosen: false, showExercises: false));
    });
  }
}
