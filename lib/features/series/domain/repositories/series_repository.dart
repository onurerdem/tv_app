import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/series.dart';

abstract class SeriesRepository {
  Future<Either<Failure, List<Series>>> getAllSeries();
  Future<Either<Failure, List<Series>>> searchSeries(String query);
  Future<Either<Failure, Series>> getSerieDetails(int serieId);
}