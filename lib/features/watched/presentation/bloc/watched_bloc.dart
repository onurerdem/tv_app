import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:tv_app/features/watched/domain/usecases/add_watched_episode.dart';
import 'package:tv_app/features/watched/presentation/bloc/watched_event.dart';
import 'package:tv_app/features/watched/presentation/bloc/watched_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../series/domain/entities/series.dart';
import '../../domain/usecases/add_watched_series.dart';
import '../../domain/usecases/get_watched_episodes.dart';
import '../../domain/usecases/get_watched_series.dart';
import '../../domain/usecases/mark_episodes_watched.dart';
import '../../domain/usecases/remove_watched_episode.dart';
import '../../domain/usecases/remove_watched_episodes.dart';
import '../../domain/usecases/remove_watched_series.dart';

class WatchedBloc extends Bloc<WatchedEvent, WatchedState> {
  final GetWatchedSeries getWatchedSeries;
  final GetWatchedEpisodes getWatchedEpisodes;
  final AddWatchedSeries addWatchedSeries;
  final RemoveWatchedSeries removeWatchedSeries;
  final SetEpisodesWatched setEpisodesWatched;
  final MarkEpisodesWatched markEpisodesWatched;
  final RemoveWatchedEpisodes removeWatchedEpisodes;
  final RemoveWatchedEpisode removeWatchedEpisode;
  final String userId;

  List<Series> _allWatchedSeries = [];
  List<Series> _filteredWatchedSeries = [];

  WatchedBloc(
    this.getWatchedSeries,
    this.getWatchedEpisodes,
    this.addWatchedSeries,
    this.removeWatchedSeries,
    this.setEpisodesWatched,
    this.markEpisodesWatched,
    this.removeWatchedEpisodes,
    this.removeWatchedEpisode,
    this.userId,
  ) : super(WatchedState.initial()) {
    on<LoadWatchedSeries>((event, emit) async {
      emit(const WatchedLoading());
      emit(WatchedLoaded(
        [],
        Series(
          id: -1,
          name: '',
          genres: [],
          scheduleDays: [],
        ),
        allWatchedSeries: [],
        filteredWatchedSeries: [],
        watchedMap: {},
        watchedEpisodesMap: {},
      ));
      final result = await getWatchedSeries(NoParams());
      result.fold(
        (failure) => emit(WatchedError("Cannot load watched series.")),
        (watchedSeries) {
          final ids = watchedSeries.map((e) => e.id).toList();
          final map = {for (var s in watchedSeries) s.id: true};
          emit(WatchedLoaded(
            ids,
            Series(
              id: -1,
              name: '',
              genres: [],
              scheduleDays: [],
            ),
            allWatchedSeries: watchedSeries,
            filteredWatchedSeries: watchedSeries,
            watchedMap: map,
            watchedEpisodesMap: {},
          ));
        },
      );
    });

    on<LoadWatchedEpisodes>((e, emit) async {
      if (state is WatchedLoaded) {
        final loaded = state as WatchedLoaded;
        final res = await getWatchedEpisodes(e.serieId);
        res.fold(
          (_) => emit(WatchedError("Cannot load watched eps.")),
          (ids) {
            final map = <int, bool>{for (var id in ids) id: true};
            emit(loaded.copyWith(watchedEpisodesMap: map));
          },
        );
      }
    });

    on<SearchSerieInWatchedSeries>((event, emit) async {
      if (state is WatchedLoading) return;

      emit(WatchedLoading());

      final result = await getWatchedSeries(NoParams());

      result.fold(
        (failure) {
          emit(WatchedError(
            "Failed to load watched series.",
          ));
        },
        (watchedSeries) {
          _allWatchedSeries = watchedSeries;

          final serieIds = watchedSeries.map((s) => s.id).toList();

          final dummySerie = Series(
            id: -1,
            name: "",
            summary: "",
            imageUrl: null,
            ratingAverage: null,
            genres: [],
            scheduleDays: [],
            scheduleTime: null,
            premiered: null,
            ended: null,
          );

          final query = event.query.trim().toLowerCase();
          if (query.isEmpty) {
            _filteredWatchedSeries = _allWatchedSeries;
          } else {
            _filteredWatchedSeries = _allWatchedSeries.where((serie) {
              return serie.name.toLowerCase().contains(query);
            }).toList();
          }

          emit(WatchedLoaded(
            serieIds,
            dummySerie,
            allWatchedSeries: _filteredWatchedSeries,
            filteredWatchedSeries: _filteredWatchedSeries,
            watchedMap: {for (var s in _filteredWatchedSeries) s.id: true},
            watchedEpisodesMap: {},
          ));
        },
      );
    });

    on<AddSeriesToWatched>((event, emit) async {
      if (state is WatchedLoaded) {
        final current = state as WatchedLoaded;
        if (current.serieIds.contains(event.serie.id)) return;

        final newList = List<Series>.from(current.allWatchedSeries)
          ..add(event.serie);
        final newIds = newList.map((s) => s.id).toList();

        final result = await addWatchedSeries(event.serie.id);
        result.fold(
          (_) => emit(WatchedError("Could not add series.")),
          (_) => emit(current.copyWith(
            serieIds: newIds,
            allWatchedSeries: newList,
            filteredWatchedSeries: newList,
            watchedMap: {for (var s in newList) s.id: true},
          )),
        );
      }
    });

    on<RemoveSeriesFromWatched>((event, emit) async {
      if (kDebugMode) {
        print("RemoveSeriesFromWatched event geldi: ${event.serie.id}");
      }
      if (state is WatchedLoaded) {
        if (kDebugMode) {
          print("RemoveSeriesFromWatched event geldi: ${event.serie.id}");
        }
        final current = state as WatchedLoaded;
        final newMap = {...current.watchedMap};
        newMap.remove(event.serie.id);
        emit(current.copyWith(watchedMap: newMap));
        if (!current.serieIds.contains(event.serie.id)) return;

        final newList = List<Series>.from(current.allWatchedSeries)
          ..removeWhere((s) => s.id == event.serie.id);
        final newIds = newList.map((s) => s.id).toList();

        final result = await removeWatchedSeries(event.serie.id);
        result.fold(
          (_) => emit(WatchedError("Could not remove series.")),
          (_) => emit(current.copyWith(
            serieIds: newIds,
            allWatchedSeries: newList,
            filteredWatchedSeries: newList,
            watchedMap: {for (var s in newList) s.id: true},
          )),
        );
      }
    });

    on<MarkAllEpisodesWatched>((event, emit) async {
      if (state is WatchedLoaded) {
        final current = state as WatchedLoaded;

        final newEpisodeMap = Map<int, bool>.from(current.watchedEpisodesMap);
        for (var eid in event.episodeIds) {
          newEpisodeMap[eid] = true;
        }

        final newSeriesMap = Map<int, bool>.from(current.watchedMap)
          ..[event.serieId] = true;

        final newSerieIds = newSeriesMap.keys.toList();

        emit(current.copyWith(
          watchedEpisodesMap: newEpisodeMap,
          watchedMap: newSeriesMap,
          serieIds: newSerieIds,
        ));

        await markEpisodesWatched(
          MarkEpisodesWatchedParams(
            userId: userId,
            serieId: event.serieId,
            episodeIds: event.episodeIds,
          ),
        );
      }
    });

    on<RemoveAllEpisodesWatched>((event, emit) async {
      if (state is WatchedLoaded) {
        final current = state as WatchedLoaded;

        final newEpisodeMap = Map<int,bool>.from(current.watchedEpisodesMap)
          ..removeWhere((key, _) => event.episodeIds.contains(key));

        final anyLeft = newEpisodeMap.values.any((v) => v);
        final newSeriesMap = Map<int,bool>.from(current.watchedMap);
        if (!anyLeft) {
          newSeriesMap.remove(event.serie.id);
        }

        final newSerieIds = newSeriesMap.keys.toList();

        emit(current.copyWith(
          watchedEpisodesMap: newEpisodeMap,
          watchedMap: newSeriesMap,
          serieIds: newSerieIds,
        ));

        await removeWatchedEpisodes(
          RemoveWatchedEpisodesParams(
            userId: userId,
            serieId: event.serie.id,
            episodeIds: event.episodeIds,
          ),
        );
      }
    });

    on<RemoveEpisodeWatched>((event, emit) async {
      if (state is WatchedLoaded) {
        final current = state as WatchedLoaded;
        final newMap = {...current.watchedMap};
        newMap.remove(event.serieId);
        emit(current.copyWith(watchedMap: newMap));
        if (!current.serieIds.contains(event.serieId)) return;

        final newList = List<Series>.from(current.allWatchedSeries)
          ..removeWhere((s) => s.id == event.serieId);
        final newIds = newList.map((s) => s.id).toList();

        emit(current.copyWith(
          serieIds: newIds,
          allWatchedSeries: newList,
          filteredWatchedSeries: newList,
          watchedMap: {for (var s in newList) s.id: true},
        ));

        final result = await removeWatchedEpisode(RemoveWatchedEpisodeParams(
          serieId: event.serieId,
          episodeId: event.episodeId,
        ));
        result.fold(
          (_) => emit(WatchedError("Could not remove series.")),
          (_) => emit(current.copyWith(
            serieIds: newIds,
            allWatchedSeries: newList,
            filteredWatchedSeries: newList,
            watchedMap: {for (var s in newList) s.id: true},
          )),
        );
      }
    });

    on<ToggleEpisodeWatched>((event, emit) async {
      if (state is WatchedLoaded) {
        final current = state as WatchedLoaded;

        final was = current.watchedEpisodesMap[event.episodeId] ?? false;
        final newEpisodeMap = Map<int, bool>.from(current.watchedEpisodesMap)
          ..[event.episodeId] = !was;

        final anyEp = newEpisodeMap.values.any((v) => v);

        final newSeriesMap = Map<int,bool>.from(current.watchedMap);
        if (anyEp) {
          newSeriesMap[event.serieId] = true;
        } else {
          newSeriesMap.remove(event.serieId);
        }

        final newSerieIds = newSeriesMap.keys.toList();

        emit(current.copyWith(
          watchedEpisodesMap: newEpisodeMap,
          watchedMap: newSeriesMap,
          serieIds: newSerieIds,
        ));

        if (was) {
          await removeWatchedEpisode(RemoveWatchedEpisodeParams(
            serieId: event.serieId,
            episodeId: event.episodeId,
          ));
        } else {
          await markEpisodesWatched(MarkEpisodesWatchedParams(
            userId: userId,
            serieId: event.serieId,
            episodeIds: [event.episodeId],
          ));
        }
      }
    });
  }
}
