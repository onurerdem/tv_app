import 'package:dartz/dartz.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../actors/domain/entities/actor.dart';
import '../repositories/favorite_actors_repository.dart';

class AddActorToFavorites implements UseCase<void, Actor> {
  final FavoriteActorsRepository repository;
  AddActorToFavorites(this.repository);

  @override
  Future<Either<Failure, void>> call(Actor actor) async {
    try {
      await repository.addActorToFavorites(actor);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
