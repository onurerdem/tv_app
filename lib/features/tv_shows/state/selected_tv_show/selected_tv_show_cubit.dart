import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/tv_shows/data/repositories/cloud_tv_shows_repository.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/episode_interface.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/state/selected_tv_show/selected_tv_show_state.dart';

class SelectedTvShowCubit extends Cubit<SelectedTvShowState> {
  SelectedTvShowCubit({
    required this.cloudTvShowsRepository,
  }) : super(SelectedTvShowLoadingState());

  final CloudTvShowsRepository cloudTvShowsRepository;

  Future<void> getTvShow({
    required String tvShowId,
  }) async {
    try {
      emit(SelectedTvShowLoadingState());

      final ITvShow tvShow = await cloudTvShowsRepository.getTvShow(
        tvShowId: tvShowId,
      );

      final List<IEpisode> tvShowEpisodes =
          await cloudTvShowsRepository.getTvShowEpisodes(
        tvShowId: tvShowId,
      );

      emit(SelectedTvShowLoadedState(
        tvShow: tvShow.copyWith(
          episodes: tvShowEpisodes,
        ),
      ));
    } catch (_) {
      emit(SelectedTvShowErrorState());
    }
  }
}