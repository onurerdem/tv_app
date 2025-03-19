part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class ChangeTabEvent extends NavigationEvent {
  final int index;
  const ChangeTabEvent(this.index);

  @override
  List<Object> get props => [index];
}

class GoBackEvent extends NavigationEvent {}