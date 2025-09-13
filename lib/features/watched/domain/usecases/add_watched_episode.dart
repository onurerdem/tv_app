import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/watched_repository.dart';

class AddWatchedEpisode {
  final String userId;
  final int serieId;
  final List<int> episodeIds;
  AddWatchedEpisode(this.userId, this.serieId, this.episodeIds);
}

class SetEpisodesWatched implements UseCase<void, AddWatchedEpisode> {
  final WatchedRepository repository;
  SetEpisodesWatched(this.repository);

  @override
  Future<Either<Failure, void>> call(AddWatchedEpisode p) {
    return repository.addWatchedEpisodes(p.userId, p.serieId, p.episodeIds);
  }
}
