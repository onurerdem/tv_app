import 'package:equatable/equatable.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

abstract class TvShowsState extends Equatable {}

class TvShowsLoadingState extends TvShowsState {
  @override
  List<Object?> get props => [];
}

class TvShowsLoadedState extends TvShowsState {
  TvShowsLoadedState({
    required this.tvShows,
    required this.currentPage,
    required this.hasNextPage,
  });

  final List<ITvShow> tvShows;
  final int currentPage;
  final bool hasNextPage;

  @override
  List<Object?> get props => [
        tvShows,
        currentPage,
        hasNextPage,
      ];
}

class TvShowsErrorState extends TvShowsState {
  @override
  List<Object?> get props => [];
}