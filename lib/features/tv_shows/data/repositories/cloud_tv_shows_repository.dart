import 'package:dio/dio.dart';
import 'package:tv_app/features/tv_shows/data/normalizers/tv_shows_repository_normalizer.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/cloud_tv_shows_repository_interface.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/episode_interface.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

class CloudTvShowsRepository extends ICloudTvShowsRepository {
   CloudTvShowsRepository({
    required this.httpClient,
  });

  final Dio httpClient;
  @override
  Future<List<ITvShow>> getTvShows({
    required int page,
  }) async {
    final List<ITvShow> tvShows = [];

    final Response<dynamic> res = await httpClient.get(
      '/shows',
    );

    for (final Map<String, dynamic> mapData in res.data) {
      tvShows.add(
        TvShowsRepositoryNormalizer.tvShowFromMap(
          mapData: mapData,
        ),
      );
    }

    return tvShows;
  }

  @override
  Future<List<ITvShow>> getTvShowsWithSearch({
    required String search,
  }) async {
    final List<ITvShow> tvShows = [];

    final Response<dynamic> res = await httpClient.get(
      '/search/shows?q=$search',
    );

    for (final Map<String, dynamic> mapData in res.data) {
      tvShows.add(
        TvShowsRepositoryNormalizer.tvShowFromMap(
          mapData: mapData['show'],
        ),
      );
    }

    return tvShows;
  }

  @override
  Future<ITvShow> getTvShow({
    required String tvShowId,
  }) async {
    final Response<dynamic> res = await httpClient.get(
      '/shows/$tvShowId',
    );

    final ITvShow tvShow = TvShowsRepositoryNormalizer.tvShowFromMap(
      mapData: res.data,
    );

    return tvShow;
  }

  @override
  Future<List<IEpisode>> getTvShowEpisodes({
    required String tvShowId,
  }) async {
    final List<IEpisode> episodes = [];

    final Response<dynamic> res = await httpClient.get(
      '/shows/$tvShowId/episodes',
    );

    for (final Map<String, dynamic> mapData in res.data) {
      episodes.add(
        TvShowsRepositoryNormalizer.episodeFromMap(
          mapData: mapData,
        ),
      );
    }

    return episodes;
  }
}