part of 'user_bloc.dart';

class UserEvent {}

class ChangeViewUserEvent extends UserEvent {
  final Widget view;
  ChangeViewUserEvent({required this.view});
}
