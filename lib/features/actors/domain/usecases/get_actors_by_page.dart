import 'package:dartz/dartz.dart';
import 'package:tv_app/features/actors/domain/entities/actor.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/actors_repository.dart';

class GetActorsByPage implements UseCase<List<Actor>, int> {
  final ActorsRepository repository;
  GetActorsByPage(this.repository);

  @override
  Future<Either<Failure, List<Actor>>> call(int page) {
    return repository.fetchActors(page);
  }
}
