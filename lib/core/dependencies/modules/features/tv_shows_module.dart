import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tv_app/features/tv_shows/data/repositories/cloud_tv_shows_repository.dart';

@module
abstract class TvShowsModule {
  @lazySingleton
  CloudTvShowsRepository cloudTvShowsRepository(
    Dio httpClient,
  ) =>
      CloudTvShowsRepository(
        httpClient: httpClient,
      );
}