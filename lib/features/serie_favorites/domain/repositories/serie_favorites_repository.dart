import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';

abstract class SerieFavoritesRepository {
  Future<void> addFavorite(int seriesId);
  Future<void> removeFavorite(int seriesId);
  Future<Either<Failure, List<int>>> getFavorites();
  Future<Either<Failure, List<Series>>> fetchFavoriteSeriesDetails();
  Future<Either<Failure, List<Series>>> getFavoriteSeries();
}
