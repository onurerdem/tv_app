import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import 'package:tv_app/features/actors/domain/repositories/actors_repository.dart';
import '../entities/actor.dart';

class GetActorDetailsUseCase extends UseCase<Actor, int> {
  final ActorsRepository repository;

  GetActorDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Actor>> call(int actorId) async {
    return await repository.getActorDetails(actorId);
  }
}
