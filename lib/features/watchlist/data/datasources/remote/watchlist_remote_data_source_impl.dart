import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tv_app/core/network/api_client.dart';
import 'package:tv_app/features/series/data/models/series_model.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';
import '../watchlist_remote_data_source.dart';
import 'package:tv_app/core/utils/constants.dart';

class WatchlistRemoteDataSourceImpl implements WatchlistRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ApiClient apiClient;

  WatchlistRemoteDataSourceImpl(
    this.auth,
    this.firestore,
    this.apiClient,
  );

  String get _userId => auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _watchlistCollection =>
      firestore.collection(USERS).doc(_userId).collection(WATCHLIST);

  @override
  Future<void> addToWatchlist(int serieId) async {
    await _watchlistCollection.doc(serieId.toString()).set({});
  }

  @override
  Future<void> removeFromWatchlist(int serieId) async {
    await _watchlistCollection.doc(serieId.toString()).delete();
  }

  @override
  Future<List<Series>> getWatchlist() async {
    final query = await _watchlistCollection.get();
    final ids = query.docs.map((doc) => int.parse(doc.id)).toList();

    final futures = ids.map((id) async {
      final response = await apiClient.get('$GET_SHOWS/$id');
      return SeriesModel.fromJson(response.data);
    }).toList();

    final seriesList = await Future.wait(futures);
    return seriesList;
  }
}
