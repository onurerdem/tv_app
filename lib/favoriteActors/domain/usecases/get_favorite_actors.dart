import 'package:dartz/dartz.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../features/actors/domain/entities/actor.dart';
import '../repositories/favorite_actors_repository.dart';

class GetFavoriteActors implements UseCase<List<Actor>, NoParams> {
  final FavoriteActorsRepository repository;

  GetFavoriteActors(this.repository);

  @override
  Future<Either<Failure, List<Actor>>> call(NoParams params) async {
    try {
      final favorites = await repository.getFavoriteActors();
      return favorites;
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
