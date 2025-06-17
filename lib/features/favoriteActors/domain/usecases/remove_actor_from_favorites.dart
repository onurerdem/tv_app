import 'package:dartz/dartz.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/favorite_actors_repository.dart';

class RemoveActorFromFavorites implements UseCase<void, int> {
  final FavoriteActorsRepository repository;

  RemoveActorFromFavorites(this.repository);

  @override
  Future<Either<Failure, void>> call(int actorId) async {
    try {
      await repository.removeActorFromFavorites(actorId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
