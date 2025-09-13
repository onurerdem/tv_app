import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/watched_repository.dart';

class RemoveWatchedSeries implements UseCase<void, int> {
  final WatchedRepository repository;
  RemoveWatchedSeries(this.repository);

  @override
  Future<Either<Failure, void>> call(int serieId) async {
    return await repository.removeWatchedSeries(serieId);
  }
}
