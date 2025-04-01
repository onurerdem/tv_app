import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import '../entities/actor.dart';

abstract class ActorsRepository {
  Future<Either<Failure, List<Actor>>> getAllActors();
  Future<Either<Failure, List<Actor>>> searchActors(String query);
}
