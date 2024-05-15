import 'package:tv_app/features/tv_shows/domain/interfaces/episode_interface.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

abstract class ICloudTvShowsRepository {
  Future<List<ITvShow>> getTvShows({
    required int page,
  });
  Future<List<ITvShow>> getTvShowsWithSearch({
    required String search,
  });
  Future<ITvShow> getTvShow({
    required String tvShowId,
  });
  Future<List<IEpisode>> getTvShowEpisodes({
    required String tvShowId,
  });
}