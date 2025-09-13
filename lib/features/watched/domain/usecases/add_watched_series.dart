import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/watched_repository.dart';

class AddWatchedSeries implements UseCase<void, int> {
  final WatchedRepository repository;
  AddWatchedSeries(this.repository);

  @override
  Future<Either<Failure, void>> call(int serieId) async {
    return await repository.addWatchedSeries(serieId);
  }
}
