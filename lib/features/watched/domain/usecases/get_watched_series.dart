import 'package:dartz/dartz.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/watched_repository.dart';

class GetWatchedSeries implements UseCase<List<Series>, NoParams> {
  final WatchedRepository repository;
  GetWatchedSeries(this.repository);

  @override
  Future<Either<Failure, List<Series>>> call(NoParams params) async {
    try {
      final getWatchedSeries = await repository.getWatchedSeries();
      return getWatchedSeries;
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
