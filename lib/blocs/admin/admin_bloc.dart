import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/views/views.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminState(view: const LogoView())) {
    on<ChangeViewEvent>((event, emit) {
      emit(AdminState(view: event.view));
    });
  }
}
