import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../actors/domain/entities/actor.dart';
import '../../domain/repositories/favorite_actors_repository.dart';
import '../datasources/favorite_actors_remote_data_source.dart';

class FavoriteActorsRepositoryImpl implements FavoriteActorsRepository {
  final FavoriteActorsRemoteDataSource favoriteActorsRemoteDataSource;

  FavoriteActorsRepositoryImpl(
    this.favoriteActorsRemoteDataSource,
  );

  @override
  Future<Either<Failure, void>> addActorToFavorites(Actor actor) async {
    try {
      return Right(await favoriteActorsRemoteDataSource.addFavoriteActor(actor as dynamic));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeActorFromFavorites(int actorId) async {
    try {
      return Right(await favoriteActorsRemoteDataSource.removeFavoriteActor(actorId));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Actor>>> getFavoriteActors() async {
    try {
      final favorites = await favoriteActorsRemoteDataSource.getFavoriteActors();
      return Right(favorites);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
