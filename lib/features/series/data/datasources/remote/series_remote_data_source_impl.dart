import 'package:dio/dio.dart';
import 'package:tv_app/core/error/exceptions.dart';
import 'package:tv_app/core/network/api_client.dart';
import 'package:tv_app/core/utils/constants.dart';
import 'package:tv_app/features/series/data/datasources/series_remote_data_source.dart';
import 'package:tv_app/features/series/data/models/series_model.dart';

import '../../models/episode_model.dart';

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
    final response = await apiClient.get('$GET_SHOWS/$serieId');
    if (response.statusCode == 200) {
      return SeriesModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<EpisodeModel>> fetchEpisodes(int serieId) async {
    try {
      final response = await apiClient.get('$GET_SHOWS/$serieId$GET_EPISODES');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((json) => EpisodeModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message:
          'Error fetching episodes: StatusCode=${response.statusCode}, Data=${response.data}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: 'DioError fetching episodes: ${e.message}',
      );
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<SeriesModel>> getSeriesByPage(int pageNumber) async {
    final response = await apiClient.get('$GET_SHOWS$GET_PAGE$pageNumber');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => SeriesModel.fromJson(json))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
