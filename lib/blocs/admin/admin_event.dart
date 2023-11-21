part of 'admin_bloc.dart';

class AdminEvent{}

class ChangeViewEvent extends AdminEvent {
  final Widget view;
  ChangeViewEvent({required this.view});
}