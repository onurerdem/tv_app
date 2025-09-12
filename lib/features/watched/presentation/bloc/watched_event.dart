import 'package:equatable/equatable.dart';
import '../../../series/domain/entities/series.dart';

abstract class WatchedEvent extends Equatable {
  const WatchedEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchedSeries extends WatchedEvent {
  @override
  List<Object?> get props => [];
}

class LoadWatchedEpisodes extends WatchedEvent {
  final int serieId;
  const LoadWatchedEpisodes(this.serieId);

  @override
  List<Object?> get props => [serieId];
}

class SearchSerieInWatchedSeries extends WatchedEvent {
  final String query;
  const SearchSerieInWatchedSeries(this.query);

  @override
  List<Object?> get props => [query];
}

class AddSeriesToWatched extends WatchedEvent {
  final Series serie;
  const AddSeriesToWatched(this.serie);

  @override
  List<Object?> get props => [serie];
}

class RemoveSeriesFromWatched extends WatchedEvent {
  final Series serie;
  const RemoveSeriesFromWatched(this.serie);

  @override
  List<Object?> get props => [serie];
}

class MarkAllEpisodesWatched extends WatchedEvent {
  final int serieId;
  final List<int> episodeIds;
  const MarkAllEpisodesWatched(this.serieId, this.episodeIds);

  @override
  List<Object?> get props => [serieId, episodeIds];
}

class RemoveAllEpisodesWatched extends WatchedEvent {
  final Series serie;
  final List<int> episodeIds;
  const RemoveAllEpisodesWatched(this.serie, this.episodeIds);

  @override
  List<Object?> get props => [serie, episodeIds];
}

class RemoveEpisodeWatched extends WatchedEvent {
  final int serieId;
  final int episodeId;
  const RemoveEpisodeWatched(this.serieId, this.episodeId);

  @override
  List<Object?> get props => [serieId, episodeId];
}

class ToggleEpisodeWatched extends WatchedEvent {
  final int serieId;
  final int episodeId;
  const ToggleEpisodeWatched(this.serieId, this.episodeId);

  @override
  List<Object?> get props => [serieId, episodeId];
}
