import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/features/actors/domain/entities/actor.dart';
import 'package:tv_app/features/actors/domain/repositories/actors_repository.dart';
import '../../../../core/usecase/usecase.dart';

class GetAllActors implements UseCase<List<Actor>, NoParams> {
  final ActorsRepository repository;

  GetAllActors(this.repository);

  @override
  Future<Either<Failure, List<Actor>>> call(NoParams params) async {
    return await repository.getAllActors();
  }
}
