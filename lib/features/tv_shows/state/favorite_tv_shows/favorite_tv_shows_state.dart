import 'package:equatable/equatable.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

abstract class FavoriteTvShowsState extends Equatable {}

class FavoriteTvShowsLoadingState extends FavoriteTvShowsState {
  @override
  List<Object?> get props => [];
}

class FavoriteTvShowsLoadedState extends FavoriteTvShowsState {
  FavoriteTvShowsLoadedState({
    required this.tvShows,
  });

  final List<ITvShow> tvShows;

  @override
  List<Object?> get props => [
        tvShows,
      ];
}

class FavoriteTvShowsErrorState extends FavoriteTvShowsState {
  @override
  List<Object?> get props => [];
}