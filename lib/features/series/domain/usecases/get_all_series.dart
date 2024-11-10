import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';
import 'package:tv_app/features/series/domain/repositories/series_repository.dart';

class GetAllSeries implements UseCase<List<Series>, NoParams> {
  final SeriesRepository repository;

  GetAllSeries(this.repository);

  @override
  Future<Either<Failure, List<Series>>> call(NoParams params) async {
    return await repository.getAllSeries();
  }
}