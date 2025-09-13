import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/watched_repository.dart';

class MarkEpisodesWatchedParams {
  final String userId;
  final int serieId;
  final List<int> episodeIds;
  MarkEpisodesWatchedParams({required this.userId, required this.serieId, required this.episodeIds});
}

class MarkEpisodesWatched implements UseCase<void, MarkEpisodesWatchedParams> {
  final WatchedRepository repository;
  MarkEpisodesWatched(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkEpisodesWatchedParams params) {
    return repository.markEpisodesWatched(params.userId, params.serieId, params.episodeIds);
  }
}
