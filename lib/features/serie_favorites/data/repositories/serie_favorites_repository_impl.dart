import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/features/serie_favorites/data/datasources/serie_favorites_remote_datasource.dart';
import 'package:tv_app/features/serie_favorites/domain/repositories/serie_favorites_repository.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';

class SerieFavoritesRepositoryImpl implements SerieFavoritesRepository {
  final SerieFavoritesRemoteDatasource remoteDatasource;
  final FirebaseFirestore firestore;

  SerieFavoritesRepositoryImpl(this.remoteDatasource, this.firestore);

  @override
  Future<Either<Failure, void>> addFavorite(int seriesId) async {
    try {
      await remoteDatasource.addFavorite(seriesId);
      return const Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int seriesId) async {
    try {
      await remoteDatasource.removeFavorite(seriesId);
      return const Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<int>>> getFavorites() async {
    try {
      final ids = await remoteDatasource.getFavorites();
      return Right(ids);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Series>>> fetchFavoriteSeriesDetails() async {
    try {
      final ids = await remoteDatasource.getFavorites();
      final models = await remoteDatasource.fetchFavoriteSeriesDetails(ids);
      return Right(models);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Series>>> getFavoriteSeries() async {
    try {
      final favorites = await remoteDatasource.getFavoriteSeries();
      return Right(favorites);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
