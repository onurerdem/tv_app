import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tv_app/core/error/exceptions.dart';
import 'package:tv_app/core/network/api_client.dart';
import 'package:tv_app/core/utils/constants.dart';
import 'package:tv_app/features/serie_favorites/data/datasources/serie_favorites_remote_datasource.dart';
import 'package:tv_app/features/series/data/models/series_model.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';

class SerieFavoritesRemoteDatasourceImpl
    implements SerieFavoritesRemoteDatasource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ApiClient apiClient;

  SerieFavoritesRemoteDatasourceImpl(this.auth, this.firestore, this.apiClient);

  @override
  Future<void> addFavorite(int seriesId) async {
    final userCollectionRef = firestore.collection("Users");
    final uid = auth.currentUser!.uid;
    await userCollectionRef
        .doc(uid)
        .collection('Favorites')
        .doc(seriesId.toString())
        .set({});
  }

  @override
  Future<void> removeFavorite(int seriesId) async {
    final userCollectionRef = firestore.collection("Users");
    final uid = auth.currentUser!.uid;
    await userCollectionRef
        .doc(uid)
        .collection('Favorites')
        .doc(seriesId.toString())
        .delete();
  }

  @override
  Future<List<int>> getFavorites() async {
    try {
      final userCollectionRef = firestore.collection("Users");
      final uid = auth.currentUser!.uid;
      final snapshot =
          await userCollectionRef.doc(uid).collection('Favorites').get();
      final favoriteIds =
          snapshot.docs.map((doc) => int.parse(doc.id)).toList();

      if (kDebugMode) {
        print(
            "FavoritesRemoteDatasourceImpl getFavorites result: $favoriteIds");
      }
      return favoriteIds;
    } catch (e, s) {
      if (kDebugMode) {
        print("FavoritesRemoteDatasourceImpl getFavorites GENERAL ERROR: $e");
        print(s);
      }
      throw Exception("Failed to fetch favorites from Firestore: $e");
    }
  }

  @override
  Future<List<SeriesModel>> fetchFavoriteSeriesDetails(List<int> ids) async {
    final List<SeriesModel> favorites = [];

    for (final id in ids) {
      final response = await apiClient.get('$GET_SHOWS/$id');
      if (response.statusCode == 200) {
        favorites.add(SeriesModel.fromJson(response.data));
      } else {
        throw ServerException();
      }
    }

    return favorites;
  }

  @override
  Future<List<Series>> getFavoriteSeries() async {
    final userCollectionRef = firestore.collection("Users");
    final uid = auth.currentUser!.uid;
    final snapshot =
        await userCollectionRef.doc(uid).collection('Favorites').get();
    final ids = snapshot.docs.map((doc) => int.parse(doc.id)).toList();

    final futures = ids.map((id) async {
      final response = await apiClient.get('$GET_SHOWS/$id');
      return SeriesModel.fromJson(response.data);
    }).toList();

    final seriesList = await Future.wait(futures);
    return seriesList;
  }
}
