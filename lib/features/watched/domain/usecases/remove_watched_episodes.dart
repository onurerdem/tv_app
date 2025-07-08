import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/watched_repository.dart';

class RemoveWatchedEpisodesParams {
  final String userId;
  final int serieId;
  final List<int> episodeIds;
  RemoveWatchedEpisodesParams({
    required this.userId,
    required this.serieId,
    required this.episodeIds,
  });
}

class RemoveWatchedEpisodes
    implements UseCase<void, RemoveWatchedEpisodesParams> {
  final WatchedRepository repository;
  RemoveWatchedEpisodes(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveWatchedEpisodesParams params) {
    return repository.removeEpisodesWatched(
      params.userId,
      params.serieId,
      params.episodeIds,
    );
  }
}
