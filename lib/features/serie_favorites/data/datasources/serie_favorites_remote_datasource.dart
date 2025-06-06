import 'package:tv_app/features/series/data/models/series_model.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';

abstract class SerieFavoritesRemoteDatasource {
  Future<void> addFavorite(int seriesId);
  Future<void> removeFavorite(int seriesId);
  Future<List<int>> getFavorites();
  Future<List<SeriesModel>> fetchFavoriteSeriesDetails(List<int> ids);
  Future<List<Series>> getFavoriteSeries();
}
