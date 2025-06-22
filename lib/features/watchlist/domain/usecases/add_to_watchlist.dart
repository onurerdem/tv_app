import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import '../repositories/watchlist_repository.dart';

class AddToWatchlist {
  final WatchlistRepository repository;
  AddToWatchlist(this.repository);

  Future<Either<Failure, void>> call(int serieId) async {
    return await repository.addToWatchlist(serieId);
  }
}
