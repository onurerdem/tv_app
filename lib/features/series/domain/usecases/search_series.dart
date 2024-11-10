import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';
import '../../../../core/usecase/usecase.dart';

class SearchSeries extends UseCase<List<Series>, String> {
  final SeriesRepository repository;

  SearchSeries(this.repository);

  @override
  Future<Either<Failure, List<Series>>> call(String query) async {
    return await repository.searchSeries(query);
  }
}