import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/tv_shows/data/repositories/local_tv_shows_repository.dart';
import 'package:tv_app/core/event_bus/event_bus_service.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/domain/events/tv_shows_events.dart';
import 'package:tv_app/features/tv_shows/state/favorite_tv_shows/favorite_tv_shows_state.dart';

class FavoriteTvShowsCubit extends Cubit<FavoriteTvShowsState> {
  FavoriteTvShowsCubit({
    required this.localTvShowsRepository,
    required this.eventBus,
  }) : super(FavoriteTvShowsLoadingState());

  final LocalTvShowsRepository localTvShowsRepository;
  final EventBus eventBus;

  StreamSubscription? _favoriteTvShowAddedEventSubscription;
  StreamSubscription? _favoriteTvShowRemovedEventSubscription;

  Future<void> initialize() async {
    _favoriteTvShowAddedEventSubscription = eventBus
        .on<FavoriteTvShowAddedEvent>()
        .listen((FavoriteTvShowAddedEvent event) => _favoriteTvShowAdded(
              tvShow: event.tvShow,
            ));

    _favoriteTvShowAddedEventSubscription = eventBus
        .on<FavoriteTvShowRemovedEvent>()
        .listen((FavoriteTvShowRemovedEvent event) => _favoriteTvShowRemoved(
              tvShowId: event.tvShowId,
            ));
  }

  @override
  Future<void> close() async {
    await _favoriteTvShowAddedEventSubscription?.cancel();
    await _favoriteTvShowRemovedEventSubscription?.cancel();
    return super.close();
  }

  Future<void> getFavoriteTvShows() async {
    try {
      emit(FavoriteTvShowsLoadingState());

      final List<ITvShow> tvShows =
          await localTvShowsRepository.getFavoriteTvShows();

      emit(FavoriteTvShowsLoadedState(
        tvShows: tvShows,
        tvShowsLength: tvShows.length,
      ));
    } catch (_) {
      emit(FavoriteTvShowsErrorState());
    }
  }
  
  void _favoriteTvShowAdded({
    required ITvShow tvShow,
  }) {
    final FavoriteTvShowsState currentState = state;
    if (currentState is FavoriteTvShowsLoadedState) {
      emit(
        FavoriteTvShowsLoadedState(
          tvShows: [tvShow, ...currentState.tvShows],
          tvShowsLength: currentState.tvShows.length,
        ),
      );
    }
  }

  void _favoriteTvShowRemoved({
    required String tvShowId,
  }) {
    final FavoriteTvShowsState currentState = state;
    if (currentState is FavoriteTvShowsLoadedState) {
      emit(
        FavoriteTvShowsLoadedState(
          tvShows: currentState.tvShows
              .where(
                (ITvShow e) => e.id != tvShowId,
              )
              .toList(),
          tvShowsLength: currentState.tvShows.length,
        ),
      );
    }
  }
}