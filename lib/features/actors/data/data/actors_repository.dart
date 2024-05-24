import 'package:dio/dio.dart';
import 'package:tv_app/features/actors/data/normalizers/actors_repository_normalizer.dart';
import 'package:tv_app/features/actors/domain/actor_interface.dart';
import 'package:tv_app/features/actors/domain/actor_repository_interface.dart';

class ActorsRepository extends IActorRepository {
  ActorsRepository({
    required this.httpClient,
  });

  final Dio httpClient;

  @override
  Future<List<IActor>> getActors({
    required int page,
  }) async {
    final List<IActor> actors = [];

    final Response<dynamic> res = await httpClient.get(
      '/people?page=$page',
    );

    for (final Map<String, dynamic> mapData in res.data) {
      actors.add(
        ActorsRepositoryNormalizer.actorFromMap(
          mapData: mapData,
        ),
      );
    }

    return actors;
  }

  @override
  Future<List<IActor>> getActorsWithSearch({
    required String search,
  }) async {
    final List<IActor> actors = [];

    final Response<dynamic> res = await httpClient.get(
      '/search/people?q=$search',
    );

    for (final Map<String, dynamic> mapData in res.data) {
      actors.add(
        ActorsRepositoryNormalizer.actorFromMap(
          mapData: mapData['person'],
        ),
      );
    }

    return actors;
  }
}