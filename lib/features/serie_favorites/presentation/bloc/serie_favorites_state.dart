part of 'serie_favorites_bloc.dart';

abstract class SerieFavoritesState extends Equatable {
  const SerieFavoritesState();

  @override
  List<Object?> get props => [];
}

class SerieFavoritesInitial extends SerieFavoritesState {
  @override
  List<Object?> get props => [];
}

class SerieFavoritesLoading extends SerieFavoritesState {
  @override
  List<Object?> get props => [];
}

class SerieFavoritesLoaded extends SerieFavoritesState {
  final List<int> favoriteIds;
  final List<Series> allFavorites;
  final List<Series> filteredFavorites;
  final Series serie;

  const SerieFavoritesLoaded(
      this.favoriteIds,
      this.serie, {
        required this.allFavorites,
        required this.filteredFavorites,
      });

  @override
  List<Object?> get props =>
      [favoriteIds, allFavorites, filteredFavorites, serie];
}

class SerieFavoritesError extends SerieFavoritesState {
  final String message;

  const SerieFavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
