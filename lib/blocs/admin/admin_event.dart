part of 'admin_bloc.dart';

@immutable
sealed class AdminEvent {}

class ChangeViewEvent extends AdminEvent {}