import 'package:dartz/dartz.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';
import '../../../../core/error/failures.dart';

abstract class WatchedRepository {
  Future<Either<Failure, void>> addWatchedSeries(int serieId);
  Future<Either<Failure, void>> removeWatchedSeries(int serieId);
  Future<Either<Failure, void>> removeWatchedEpisode(
    int serieId,
    int episodeId,
  );
  Future<Either<Failure, void>> addWatchedEpisodes(
    String userId,
    int serieId,
    List<int> episodeIds,
  );
  Future<Either<Failure, void>> markEpisodesWatched(
    String userId,
    int serieId,
    List<int> episodeIds,
  );
  Future<Either<Failure, void>> removeEpisodesWatched(
    String userId,
    int serieId,
    List<int> episodeIds,
  );
  Future<Either<Failure, List<Series>>> getWatchedSeries();
  Future<Either<Failure, List<int>>> getWatchedEpisodeIds(int serieId);
}
