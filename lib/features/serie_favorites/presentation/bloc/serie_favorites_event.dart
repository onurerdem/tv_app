part of 'serie_favorites_bloc.dart';

abstract class SerieFavoritesEvent extends Equatable {
  const SerieFavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadSerieFavorites extends SerieFavoritesEvent {
  @override
  List<Object?> get props => [];
}

class SearchSerieFavorites extends SerieFavoritesEvent {
  final String query;
  const SearchSerieFavorites(this.query);

  @override
  List<Object?> get props => [query];
}

class AddSerieToFavorites extends SerieFavoritesEvent {
  final Series serie;

  const AddSerieToFavorites(this.serie);

  @override
  List<Object?> get props => [serie];
}

class RemoveSerieFromFavorites extends SerieFavoritesEvent {
  final Series serie;

  const RemoveSerieFromFavorites(this.serie);

  @override
  List<Object?> get props => [serie];
}
