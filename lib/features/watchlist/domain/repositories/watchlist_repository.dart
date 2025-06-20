import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, void>> addToWatchlist(int serieId);
  Future<Either<Failure, void>> removeFromWatchlist(int serieId);
  Future<Either<Failure, List<Series>>> getWatchlist();
}
