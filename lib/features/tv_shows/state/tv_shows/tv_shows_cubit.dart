import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/tv_shows/data/repositories/cloud_tv_shows_repository.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/state/tv_shows/tv_shows.state.dart';

class TvShowsCubit extends Cubit<TvShowsState> {
  TvShowsCubit({
    required this.cloudTvShowsRepository,
  }) : super(TvShowsLoadingState());

  final CloudTvShowsRepository cloudTvShowsRepository;

  Future<void> getTvShows() async {
    try {
      emit(TvShowsLoadingState());

      final List<ITvShow> tvShows = await cloudTvShowsRepository.getTvShows(
        page: 1,
      );

      emit(
        TvShowsLoadedState(
          tvShows: tvShows,
          currentPage: 1,
          hasNextPage: tvShows.isNotEmpty,
        ),
      );
    } catch (_) {
      emit(TvShowsErrorState());
    }
  }

  Future<void> getTvShowsNextPage() async {
    final TvShowsState currentState = state;
    if (currentState is TvShowsLoadedState) {
      final List<ITvShow> newTvShows = await cloudTvShowsRepository.getTvShows(
        page: 1,
      );

      emit(
        TvShowsLoadedState(
          tvShows: currentState.tvShows..addAll(newTvShows),
          currentPage: currentState.currentPage + 1,
          hasNextPage: newTvShows.isNotEmpty,
        ),
      );
    }
  }
}