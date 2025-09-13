import 'package:tv_app/features/series/domain/entities/series.dart';

abstract class WatchedRemoteDataSource {
  Future<void> addWatchedSeries(int serieId);
  Future<void> removeWatchedSeries(int serieId);

  Future<void> addWatchedEpisode(int serieId, int episodeId);
  Future<void> removeWatchedEpisode(int serieId, int episodeId);

  Future<void> addWatchedEpisodes(
    String userId,
    int serieId,
    List<int> episodeIds,
  );

  Future<void> markEpisodesWatched(
    String userId,
    int serieId,
    List<int> episodeIds,
  );

  Future<void> removeEpisodesWatched(
    String userId,
    int serieId,
    List<int> episodeIds,
  );

  Future<List<Series>> getWatchedSeries();
  Future<List<int>> getWatchedEpisodeIds(int serieId);
}
