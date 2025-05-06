import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/series.dart';
import '../../domain/repositories/series_repository.dart';
import '../datasources/series_remote_data_source.dart';

class SeriesRepositoryImpl implements SeriesRepository {
  final SeriesRemoteDataSource remoteDataSource;

  SeriesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Series>>> getAllSeries() async {
    try {
      final series = await remoteDataSource.getAllSeries();
      return Right(series);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Series>>> searchSeries(String query) async {
    try {
      final series = await remoteDataSource.searchSeries(query);
      return Right(series);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Series>> getSerieDetails(int serieId) async {
    try {
      final serie = await remoteDataSource.getSerieDetails(serieId);
      return Right(serie);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Episode>>> getEpisodes(int showId) async {
    try {
      final episodes = await remoteDataSource.fetchEpisodes(showId);
      return Right(episodes);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}