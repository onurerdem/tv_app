import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetSeriesByPage implements UseCase<List<Series>, int> {
  final SeriesRepository repository;

  GetSeriesByPage(this.repository);

  @override
  Future<Either<Failure, List<Series>>> call(int page) async {
    return await repository.getSeriesByPage(page);
  }
}