import 'package:tv_app/features/series/data/models/series_model.dart';

abstract class SeriesRemoteDataSource {

  Future<List<SeriesModel>> getAllSeries();
  Future<List<SeriesModel>> searchSeries(String query);

}