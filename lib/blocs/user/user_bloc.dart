import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/views/logo_view.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(view: const LogoView())) {
    on<ChangeViewUserEvent>((event, emit) {
      emit(UserState(view: event.view));
    });
  }
}
