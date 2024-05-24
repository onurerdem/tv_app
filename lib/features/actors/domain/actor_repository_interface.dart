import 'package:tv_app/features/actors/domain/actor_interface.dart';

abstract class IActorRepository {
  Future<List<IActor>> getActors({
    required int page,
  });
  Future<List<IActor>> getActorsWithSearch({
    required String search,
  });
}