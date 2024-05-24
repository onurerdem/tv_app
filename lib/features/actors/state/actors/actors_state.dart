import 'package:equatable/equatable.dart';
import 'package:tv_app/features/actors/domain/actor_interface.dart';

abstract class ActorsState extends Equatable {}

class ActorsLoadingState extends ActorsState {
  @override
  List<Object?> get props => [];
}

class ActorsLoadedState extends ActorsState {
  ActorsLoadedState({
    required this.actors,
    required this.currentPage,
    required this.hasNextPage,
  });

  final List<IActor> actors;
  final int currentPage;
  final bool hasNextPage;

  @override
  List<Object?> get props => [
        actors,
        currentPage,
        hasNextPage,
      ];
}

class ActorsErrorState extends ActorsState {
  @override
  List<Object?> get props => [];
}