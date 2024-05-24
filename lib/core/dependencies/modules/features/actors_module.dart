import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tv_app/features/actors/data/data/actors_repository.dart';

@module
abstract class ActorsModule {
  @lazySingleton
  ActorsRepository actorsRepository(
    Dio httpClient,
  ) =>
      ActorsRepository(
        httpClient: httpClient,
      );
}