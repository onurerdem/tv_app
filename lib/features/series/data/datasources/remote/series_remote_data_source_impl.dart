import 'package:tv_app/core/error/exceptions.dart';
import 'package:tv_app/core/network/api_client.dart';
import 'package:tv_app/core/utils/constants.dart';
import 'package:tv_app/features/series/data/datasources/series_remote_data_source.dart';
import 'package:tv_app/features/series/data/models/series_model.dart';

class SeriesRemoteDataSourceImpl implements SeriesRemoteDataSource {
  final ApiClient apiClient;

  SeriesRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<SeriesModel>> getAllSeries() async {
    final response = await apiClient.get(GET_SHOWS);
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => SeriesModel.fromJson(json))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SeriesModel>> searchSeries(String query) async {
    final response = await apiClient.get('$GET_SEARCH_SHOWS$query');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => SeriesModel.fromJson(json))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SeriesModel> getSerieDetails(int serieId) async {
    final response = await apiClient.get('$GET_SHOWS/${serieId}');
    if (response.statusCode == 200) {
      return SeriesModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
