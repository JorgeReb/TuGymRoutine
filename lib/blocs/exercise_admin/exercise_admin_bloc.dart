import 'package:bloc/bloc.dart';


part 'exercise_admin_event.dart';
part 'exercise_admin_state.dart';

class ExerciseAdminBloc extends Bloc<ExerciseAdminEvent, ExerciseAdminState> {
  ExerciseAdminBloc() : super(const ExerciseAdminState(isEnabled: false)) {
    on<ChangeEnabledInputs>((event, emit) {
      emit(ExerciseAdminState(isEnabled: event.isEnabled));
    });
    on<DisposeEvent>((event, emit) {
      emit(ExerciseAdminState(isEnabled: event.isEnabled));
    });

  }
}
