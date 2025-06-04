import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import '../repositories/serie_favorites_repository.dart';

class RemoveFavorite implements UseCase<void, int> {
  final SerieFavoritesRepository repository;

  RemoveFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(int seriesId) async {
    try {
      await repository.removeFavorite(seriesId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
