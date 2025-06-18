import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../actors/domain/entities/actor.dart';

abstract class FavoriteActorsRepository {
  Future<Either<Failure, void>> addActorToFavorites(Actor actor);
  Future<Either<Failure, void>> removeActorFromFavorites(int actorId);
  Future<Either<Failure, List<Actor>>> getFavoriteActors();
}
