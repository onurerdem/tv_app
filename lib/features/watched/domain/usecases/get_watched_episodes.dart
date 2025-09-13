import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/watched_repository.dart';

class GetWatchedEpisodes implements UseCase<List<int>, int> {
  final WatchedRepository repository;
  GetWatchedEpisodes(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(int serieId) {
    return repository.getWatchedEpisodeIds(serieId);
  }
}
