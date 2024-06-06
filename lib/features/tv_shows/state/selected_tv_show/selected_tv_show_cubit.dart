import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/event_bus/event_bus_service.dart';
import 'package:tv_app/features/tv_shows/data/repositories/cloud_tv_shows_repository.dart';
import 'package:tv_app/features/tv_shows/data/repositories/local_tv_shows_repository.dart';
import 'package:tv_app/features/tv_shows/domain/events/tv_shows_events.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/episode_interface.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/state/selected_tv_show/selected_tv_show_state.dart';

class SelectedTvShowCubit extends Cubit<SelectedTvShowState> {
  SelectedTvShowCubit({
    required this.cloudTvShowsRepository,
    required this.localTvShowsRepository,
    required this.eventBus,
  }) : super(SelectedTvShowLoadingState());

  final CloudTvShowsRepository cloudTvShowsRepository;
  final LocalTvShowsRepository localTvShowsRepository;
  final EventBus eventBus;

  StreamSubscription? _favoriteTvShowAddedEventSubscription;
  StreamSubscription? _favoriteTvShowRemovedEventSubscription;

  Future<void> initialize() async {
    _favoriteTvShowAddedEventSubscription = eventBus
        .on<FavoriteTvShowAddedEvent>()
        .listen((FavoriteTvShowAddedEvent event) => _favoriteTvShowAdded());

    _favoriteTvShowAddedEventSubscription = eventBus
        .on<FavoriteTvShowRemovedEvent>()
        .listen((FavoriteTvShowRemovedEvent event) => _favoriteTvShowRemoved());
  }

  @override
  Future<void> close() async {
    await _favoriteTvShowAddedEventSubscription?.cancel();
    await _favoriteTvShowRemovedEventSubscription?.cancel();
    return super.close();
  }

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

      final bool isFavorite =
          await localTvShowsRepository.isFavorite(tvShowId: tvShowId);

      emit(SelectedTvShowLoadedState(
        tvShow: tvShow.copyWith(
          episodes: tvShowEpisodes,
        ),
        isFavorite: isFavorite,
      ));
    } catch (_) {
      emit(SelectedTvShowErrorState());
    }
  }
  
  void _favoriteTvShowAdded() {
    final SelectedTvShowState currentState = state;
    if (currentState is SelectedTvShowLoadedState) {
      emit(SelectedTvShowLoadedState(
        tvShow: currentState.tvShow,
        isFavorite: true,
      ));
    }
  }

  void _favoriteTvShowRemoved() {
    final SelectedTvShowState currentState = state;
    if (currentState is SelectedTvShowLoadedState) {
      emit(SelectedTvShowLoadedState(
        tvShow: currentState.tvShow,
        isFavorite: false,
      ));
    }
  }
}