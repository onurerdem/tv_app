import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/tv_shows/data/repositories/cloud_tv_shows_repository.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/state/tv_shows/tv_show_state.dart';

class TvShowsCubit extends Cubit<TvShowsState> {
  TvShowsCubit({
    required this.cloudTvShowsRepository,
  }) : super(TvShowsLoadingState());

  final CloudTvShowsRepository cloudTvShowsRepository;

  Future<void> getTvShows({
    required String? search,
  }) async {
    List<ITvShow> tvShows = [];
    try {
      emit(TvShowsLoadingState());

      if (search != null) {
        tvShows.addAll(
          await cloudTvShowsRepository.getTvShowsWithSearch(
            search: search,
          ),
        );
      } else {
        tvShows.addAll(
          await cloudTvShowsRepository.getTvShows(
            page: 1,
          ),
        );
      }

      emit(
        TvShowsLoadedState(
          tvShows: tvShows,
          currentPage: 1,
          hasNextPage: search != null ? false : tvShows.isNotEmpty,
        ),
      );
    } catch (_, __) {
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