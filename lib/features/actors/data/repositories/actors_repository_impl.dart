import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import '../../domain/entities/actor.dart';
import '../../domain/entities/actor_cast_credit_entity.dart';
import '../../domain/repositories/actors_repository.dart';
import '../datasources/actors_remote_data_source.dart';

class ActorsRepositoryImpl implements ActorsRepository {
  final ActorsRemoteDataSource remoteDataSource;

  ActorsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Actor>>> getAllActors() async {
    try {
      final actorModels = await remoteDataSource.getAllActors();
      return Right(actorModels);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Actor>>> searchActors(String query) async {
    try {
      final actorModels = await remoteDataSource.searchActors(query);
      return Right(actorModels);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Actor>> getActorDetails(int actorId) async {
    try {
      final actorDetails = await remoteDataSource.getActorDetails(actorId);
      return Right(actorDetails);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ActorCastCreditEntity>>> getActorCastCredits(
      int actorId) async {
    try {
      final actorCastCredits = await remoteDataSource.getActorCastCredits(actorId);
      return Right(actorCastCredits);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Actor>>> fetchActors(int page) async {
    try {
      final actors = await remoteDataSource.fetchActors(page);
      return Right(actors);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
