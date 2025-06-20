import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import '../repositories/watchlist_repository.dart';

class RemoveFromWatchlist {
  final WatchlistRepository repository;
  RemoveFromWatchlist(this.repository);

  Future<Either<Failure, void>> call(int serieId) async {
    return await repository.removeFromWatchlist(serieId);
  }
}
