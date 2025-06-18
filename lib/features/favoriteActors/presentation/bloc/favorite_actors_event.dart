import 'package:equatable/equatable.dart';
import '../../../actors/domain/entities/actor.dart';

abstract class FavoriteActorsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoriteActorsEvent {}

class SearchFavoriteActors extends FavoriteActorsEvent {
  final String query;
  SearchFavoriteActors(this.query);

  @override
  List<Object?> get props => [query];
}

class AddToFavoritesEvent extends FavoriteActorsEvent {
  final Actor actor;
  AddToFavoritesEvent(this.actor);

  @override
  List<Object?> get props => [actor];
}

class RemoveFromFavoritesEvent extends FavoriteActorsEvent {
  final Actor actor;
  RemoveFromFavoritesEvent(this.actor);

  @override
  List<Object?> get props => [actor];
}
