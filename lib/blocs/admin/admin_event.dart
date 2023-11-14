part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent{}

class ChangeViewEvent extends AdminEvent {
  final Widget view;

  ChangeViewEvent({required this.view});

}