import 'package:equatable/equatable.dart';
import '../../../series/domain/entities/series.dart';

class WatchedState extends Equatable {
  final List<int> serieIds;
  final List<Series> allWatchedSeries;
  final List<Series> filteredWatchedSeries;
  final Map<int, bool> watchedMap;
  final Map<int, bool> watchedEpisodesMap;

  const WatchedState.initial()
      : serieIds = const [],
        allWatchedSeries = const [],
        filteredWatchedSeries = const [],
        watchedMap = const {},
        watchedEpisodesMap = const {};

  const WatchedState({
    required this.serieIds,
    required this.allWatchedSeries,
    required this.filteredWatchedSeries,
    required this.watchedMap,
    required this.watchedEpisodesMap,
  });

  WatchedState copyWith({
    List<int>? serieIds,
    List<Series>? allWatchedSeries,
    List<Series>? filteredWatchedSeries,
    Map<int, bool>? watchedMap,
    Map<int, bool>? watchedEpisodesMap,
  }) {
    return WatchedLoaded(
      serieIds ?? this.serieIds,
      Series(id: -1, name: '', genres: [], scheduleDays: []),
      allWatchedSeries: allWatchedSeries ?? this.allWatchedSeries,
      filteredWatchedSeries:
          filteredWatchedSeries ?? this.filteredWatchedSeries,
      watchedMap: watchedMap ?? this.watchedMap,
      watchedEpisodesMap: watchedEpisodesMap ?? this.watchedEpisodesMap,
    );
  }

  @override
  List<Object?> get props =>
      [serieIds, allWatchedSeries, filteredWatchedSeries, watchedMap];
}

class WatchedInitial extends WatchedState {
  const WatchedInitial() : super.initial();
}

class WatchedLoading extends WatchedState {
  const WatchedLoading() : super.initial();
}

class WatchedLoaded extends WatchedState {
  final List<int> serieIds;
  final List<Series> allWatchedSeries;
  final List<Series> filteredWatchedSeries;
  final Series serie;
  final Map<int, bool> watchedMap;
  final Map<int, bool> watchedEpisodesMap;

  const WatchedLoaded(
    this.serieIds,
    this.serie, {
    required this.allWatchedSeries,
    required this.filteredWatchedSeries,
    required this.watchedMap,
    required this.watchedEpisodesMap,
  }) : super(
          serieIds: serieIds,
          allWatchedSeries: allWatchedSeries,
          filteredWatchedSeries: filteredWatchedSeries,
          watchedMap: watchedMap,
          watchedEpisodesMap: watchedEpisodesMap,
        );

  @override
  List<Object?> get props => [
        serieIds,
        allWatchedSeries,
        filteredWatchedSeries,
        serie,
        watchedMap,
        watchedEpisodesMap
      ];
}

class WatchedSuccess extends WatchedState {
  const WatchedSuccess() : super.initial();
}

class WatchedError extends WatchedState {
  final String message;
  WatchedError(this.message)
      : super(
          serieIds: [],
          allWatchedSeries: const [],
          filteredWatchedSeries: const [],
          watchedMap: {},
          watchedEpisodesMap: {},
        );

  @override
  List<Object?> get props => [message];
}
