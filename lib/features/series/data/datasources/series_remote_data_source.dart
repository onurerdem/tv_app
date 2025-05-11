import 'package:tv_app/features/series/data/models/series_model.dart';

import '../models/episode_model.dart';

abstract class SeriesRemoteDataSource {

  Future<List<SeriesModel>> getAllSeries();
  Future<List<SeriesModel>> searchSeries(String query);
  Future<SeriesModel> getSerieDetails(int serieId);
  Future<List<EpisodeModel>> fetchEpisodes(int showId);
  Future<List<SeriesModel>> getSeriesByPage(int pageNumber);

}