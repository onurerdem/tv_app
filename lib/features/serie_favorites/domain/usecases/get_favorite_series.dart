import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import 'package:tv_app/features/serie_favorites/domain/repositories/serie_favorites_repository.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';

class GetFavoriteSeries implements UseCase<List<Series>, NoParams> {
  final SerieFavoritesRepository repository;

  GetFavoriteSeries(this.repository);

  @override
  Future<Either<Failure, List<Series>>> call(NoParams params) async {
    try {
      final favorites = await repository.getFavoriteSeries();
      return favorites;
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}