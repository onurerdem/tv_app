import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_remote_data_source.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistRemoteDataSource remoteDataSource;

  WatchlistRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> addToWatchlist(int serieId) async {
    try {
      await remoteDataSource.addToWatchlist(serieId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWatchlist(int serieId) async {
    try {
      await remoteDataSource.removeFromWatchlist(serieId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Series>>> getWatchlist() async {
    try {
      final series = await remoteDataSource.getWatchlist();
      return Right(series);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
