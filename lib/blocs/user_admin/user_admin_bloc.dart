import 'package:bloc/bloc.dart';

part 'user_admin_event.dart';
part 'user_admin_state.dart';

class UserAdminBloc extends Bloc<UserAdminEvent, UserAdminState> {
  UserAdminBloc() : super(const UserAdminState(isEnabled: false)) {
    on<ChangeEnabledInputs>((event, emit) {
      emit(UserAdminState(isEnabled: event.isEnabled));
    });
    on<DisposeEvent>((event, emit) {
      emit(UserAdminState(isEnabled: event.isEnabled));
    });
  }
}
