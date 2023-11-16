part of 'exercise_admin_bloc.dart';


class ExerciseAdminEvent {}

class ChangeEnabledInputs extends ExerciseAdminEvent{
  final bool isEnabled;
  ChangeEnabledInputs({required this.isEnabled});
}

class DisposeEvent extends ExerciseAdminEvent{
  final bool isEnabled;
  DisposeEvent({required this.isEnabled});
}




