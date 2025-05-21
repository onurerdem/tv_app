import 'package:equatable/equatable.dart';
import '../../domain/entities/actor.dart';

abstract class ActorsState extends Equatable {
  const ActorsState();

  @override
  List<Object?> get props => [];
}

class ActorsInitial extends ActorsState {}

class ActorsLoading extends ActorsState {}

class ActorsLoaded extends ActorsState {
  final List<Actor> actors;
  final bool hasReachedMax;

  const ActorsLoaded({required this.actors, required this.hasReachedMax});

  @override
  List<Object?> get props => [actors];
}

class ActorsError extends ActorsState {
  final String message;

  const ActorsError(this.message);

  @override
  List<Object?> get props => [message];
}
