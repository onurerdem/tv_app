import 'package:equatable/equatable.dart';
import '../../../actors/domain/entities/actor.dart';

abstract class FavoriteActorsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoriteActorsState {}

class FavoritesLoading extends FavoriteActorsState {}

class FavoritesLoaded extends FavoriteActorsState {
  final Actor actorDetails;
  final List<Actor> favoriteActors;
  FavoritesLoaded(this.favoriteActors, this.actorDetails);

  @override
  List<Object?> get props => [favoriteActors, actorDetails];
}

class FavoritesError extends FavoriteActorsState {
  final String message;
  FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
