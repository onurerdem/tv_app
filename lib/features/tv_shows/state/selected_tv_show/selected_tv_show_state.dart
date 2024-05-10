import 'package:equatable/equatable.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

abstract class SelectedTvShowState extends Equatable {}

class SelectedTvShowLoadingState extends SelectedTvShowState {
  @override
  List<Object?> get props => [];
}

class SelectedTvShowLoadedState extends SelectedTvShowState {
  SelectedTvShowLoadedState({
    required this.tvShow,
  });

  final ITvShow tvShow;

  @override
  List<Object?> get props => [
        tvShow,
      ];
}

class SelectedTvShowErrorState extends SelectedTvShowState {
  @override
  List<Object?> get props => [];
}