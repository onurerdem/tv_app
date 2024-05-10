import 'package:tv_app/features/tv_shows/domain/interfaces/local_tv_shows_repository_interface.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

class LocalTvShowsRepository extends ILocalTvShowsRepository {
  @override
  Future<List<ITvShow>> getFavoriteTvShows() async {
    throw UnimplementedError();
  }

  @override
  Future<void> addFavoriteTvShow({
    required ITvShow tvShow,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> remodeFavoriteTv({
    required String tvShowId,
  }) async {
    throw UnimplementedError();
  }
}