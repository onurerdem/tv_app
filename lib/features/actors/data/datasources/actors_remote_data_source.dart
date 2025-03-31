import '../models/actor_model.dart';

abstract class ActorsRemoteDataSource {
  Future<List<ActorModel>> getAllActors();
  Future<List<ActorModel>> searchActors(String query);
}
