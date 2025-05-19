import '../models/actor_cast_credit_model.dart';
import '../models/actor_model.dart';

abstract class ActorsRemoteDataSource {
  Future<List<ActorModel>> getAllActors();
  Future<List<ActorModel>> searchActors(String query);
  Future<ActorModel> getActorDetails(int actorId);
  Future<List<ActorCastCreditModel>> getActorCastCredits(int actorId);
  Future<List<ActorModel>> fetchActors(int page);
}
