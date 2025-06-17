import '../../../actors/data/models/actor_model.dart';

abstract class FavoriteActorsRemoteDataSource {
  Future<void> addFavoriteActor(ActorModel actor);
  Future<void> removeFavoriteActor(int actorId);
  Future<List<ActorModel>> getFavoriteActors();
}
