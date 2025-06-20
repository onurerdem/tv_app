import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';
import '../repositories/watchlist_repository.dart';

class GetWatchlist {
  final WatchlistRepository repository;
  GetWatchlist(this.repository);

  Future<Either<Failure, List<Series>>> call() async {
    try {
      final watchlist = await repository.getWatchlist();
      return watchlist;
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
