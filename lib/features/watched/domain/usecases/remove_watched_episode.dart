import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/watched_repository.dart';

class RemoveWatchedEpisodeParams {
  final int serieId;
  final int episodeId;
  RemoveWatchedEpisodeParams({
    required this.serieId,
    required this.episodeId,
  });
}

class RemoveWatchedEpisode
    implements UseCase<void, RemoveWatchedEpisodeParams> {
  final WatchedRepository repository;
  RemoveWatchedEpisode(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveWatchedEpisodeParams params) {
    return repository.removeWatchedEpisode(
      params.serieId,
      params.episodeId,
    );
  }
}
