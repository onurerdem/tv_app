import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

abstract class ILocalTvShowsRepository {
  Future<List<ITvShow>> getFavoriteTvShows();
  Future<void> addFavoriteTvShow({
    required ITvShow tvShow,
  });
  Future<void> remodeFavoriteTv({
    required String tvShowId,
  });
}