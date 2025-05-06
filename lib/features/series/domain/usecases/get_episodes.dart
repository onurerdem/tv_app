import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/episode.dart';
import '../repositories/series_repository.dart';

class GetEpisodes implements UseCase<List<Episode>, int> {
  final SeriesRepository repository;
  GetEpisodes(this.repository);

  @override
  Future<Either<Failure, List<Episode>>> call(int params) {
    return repository.getEpisodes(params);
  }
}
