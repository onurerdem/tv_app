import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import '../entities/actor.dart';
import '../entities/actor_cast_credit_entity.dart';

abstract class ActorsRepository {
  Future<Either<Failure, List<Actor>>> getAllActors();
  Future<Either<Failure, List<Actor>>> searchActors(String query);
  Future<Either<Failure, Actor>> getActorDetails(int actorId);
  Future<Either<Failure, List<ActorCastCreditEntity>>> getActorCastCredits(int actorId);
  Future<Either<Failure, List<Actor>>> fetchActors(int page);
}
