import 'package:dartz/dartz.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/watched_repository.dart';
import '../datasources/watched_remote_data_source.dart';

class WatchedRepositoryImpl implements WatchedRepository {
  final WatchedRemoteDataSource remote;

  WatchedRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, void>> addWatchedSeries(int serieId) async {
    try {
      await remote.addWatchedSeries(serieId);
      return const Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeWatchedSeries(int serieId) async {
    try {
      await remote.removeWatchedSeries(serieId);
      return const Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Series>>> getWatchedSeries() async {
    try {
      final list = await remote.getWatchedSeries();
      return Right(list);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<int>>> getWatchedEpisodeIds(int serieId) async {
    try {
      final ids = await remote.getWatchedEpisodeIds(serieId);
      return Right(ids);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addWatchedEpisodes(
    String userId,
    int serieId,
    List<int> episodeIds,
  ) async {
    try {
      await remote.addWatchedEpisodes(userId, serieId, episodeIds);
      return Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeWatchedEpisode(
    int serieId,
    int episodeId,
  ) async {
    try {
      await remote.removeWatchedEpisode(serieId, episodeId);
      return Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markEpisodesWatched(
    String userId,
    int serieId,
    List<int> episodeIds,
  ) async {
    try {
      await remote.markEpisodesWatched(userId, serieId, episodeIds);
      return Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeEpisodesWatched(
    String userId,
    int serieId,
    List<int> episodeIds,
  ) async {
    try {
      await remote.removeEpisodesWatched(
        userId,
        serieId,
        episodeIds,
      );
      return const Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
