import 'package:tv_app/features/series/domain/entities/series.dart';

abstract class WatchlistRemoteDataSource {
  Future<void> addToWatchlist(int serieId);
  Future<void> removeFromWatchlist(int serieId);
  Future<List<Series>> getWatchlist();
}
