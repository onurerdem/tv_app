import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetSerieDetails implements UseCase<Series, int> {
  final SeriesRepository repository;

  GetSerieDetails(this.repository);

  @override
  Future<Either<Failure, Series>> call(int serieId) async {
    return await repository.getSerieDetails(serieId);
  }
}
