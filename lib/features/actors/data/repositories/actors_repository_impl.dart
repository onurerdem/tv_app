import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import '../../domain/entities/actor.dart';
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
}
