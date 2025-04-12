import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import '../entities/actor.dart';
import '../repositories/actors_repository.dart';

class SearchActors implements UseCase<List<Actor>, String> {
  final ActorsRepository repository;

  SearchActors(this.repository);

  @override
  Future<Either<Failure, List<Actor>>> call(String query) async {
    return await repository.searchActors(query);
  }
}
