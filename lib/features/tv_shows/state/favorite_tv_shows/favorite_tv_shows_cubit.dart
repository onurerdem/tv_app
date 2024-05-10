import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/tv_shows/data/repositories/local_tv_shows_repository.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/state/favorite_tv_shows/favorite_tv_shows_state.dart';

class FavoriteTvShowsCubit extends Cubit<FavoriteTvShowsState> {
  FavoriteTvShowsCubit({
    required this.localTvShowsRepository,
  }) : super(FavoriteTvShowsLoadingState());

  final LocalTvShowsRepository localTvShowsRepository;

  Future<void> getTvShows() async {
    try {
      emit(FavoriteTvShowsLoadingState());

      final List<ITvShow> tvShows =
          await localTvShowsRepository.getFavoriteTvShows();

      emit(FavoriteTvShowsLoadedState(
        tvShows: tvShows,
      ));
    } catch (_) {
      emit(FavoriteTvShowsErrorState());
    }
  }
}