import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import '../repositories/serie_favorites_repository.dart';

class GetFavorites implements UseCase<List<int>, NoParams> {
  final SerieFavoritesRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(NoParams params) async {
    try {
      final favorites = await repository.getFavorites();
      return favorites;
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
