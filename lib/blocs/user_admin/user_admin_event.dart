part of 'user_admin_bloc.dart';


class UserAdminEvent {}

class ChangeEnabledInputs extends UserAdminEvent{
  final bool isEnabled;
  ChangeEnabledInputs({required this.isEnabled});
}

class DisposeEvent extends UserAdminEvent{
  final bool isEnabled;
  DisposeEvent({required this.isEnabled});
}


