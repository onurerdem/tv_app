import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/features/actors/domain/entities/actor_cast_credit_entity.dart';
import 'package:tv_app/features/actors/domain/repositories/actors_repository.dart';

class GetActorCastCreditsUseCase {
  final ActorsRepository repository;

  GetActorCastCreditsUseCase(this.repository);

  Future<Either<Failure, List<ActorCastCreditEntity>>> call(int actorId) {
    return repository.getActorCastCredits(actorId);
  }
}
