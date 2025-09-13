import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../series/data/models/series_model.dart';
import '../../../../series/domain/entities/series.dart';
import '../watched_remote_data_source.dart';

class WatchedRemoteDataSourceImpl implements WatchedRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ApiClient apiClient;

  WatchedRemoteDataSourceImpl(
    this.auth,
    this.firestore,
    this.apiClient,
  );

  String get _userId => auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _watchlistCollection =>
      firestore.collection(USERS).doc(_userId).collection(WATCHED);

  @override
  Future<void> addWatchedSeries(int serieId) async {
    await _watchlistCollection
        .doc(serieId.toString())
        .set({});
  }

  @override
  Future<void> removeWatchedSeries(int serieId) async {
    await _watchlistCollection.doc(serieId.toString()).delete();
  }

  @override
  Future<void> addWatchedEpisode(int serieId, int episodeId) async {
    await _watchlistCollection
        .doc(serieId.toString())
        .collection(EPISODES)
        .doc(episodeId.toString())
        .set({});
  }

  @override
  Future<void> removeWatchedEpisode(int serieId, int episodeId) async {
    await _watchlistCollection
        .doc(serieId.toString())
        .collection(EPISODES)
        .doc(episodeId.toString())
        .delete();

    final episodes = await _watchlistCollection
        .doc(serieId.toString())
        .collection(EPISODES)
        .get();

    if (episodes.docs.isEmpty) {
      await _watchlistCollection.doc(serieId.toString()).delete();
    }
  }

  @override
  Future<void> addWatchedEpisodes(
    String userId,
    int serieId,
    List<int> episodeIds,
  ) async {
    final serieDoc = firestore
        .collection(USERS)
        .doc(userId)
        .collection(WATCHED)
        .doc(serieId.toString());
    await serieDoc.set({});
    final batch = firestore.batch();
    for (var eid in episodeIds) {
      final epDoc = serieDoc.collection(EPISODES).doc(eid.toString());
      batch.set(epDoc, {});
    }
    await batch.commit();
  }

  @override
  Future<void> markEpisodesWatched(
    String userId,
    int serieId,
    List<int> episodeIds,
  ) async {
    final serieDoc = firestore
        .collection(USERS)
        .doc(userId)
        .collection(WATCHED)
        .doc(serieId.toString());
    await serieDoc.set({});

    for (var episodeId in episodeIds) {
      await serieDoc.collection(EPISODES).doc(episodeId.toString()).set({});
    }
  }

  @override
  Future<void> removeEpisodesWatched(
    String userId,
    int serieId,
    List<int> episodeIds,
  ) async {
    final serieDoc = firestore
        .collection(USERS)
        .doc(userId)
        .collection(WATCHED)
        .doc(serieId.toString());

    for (var eid in episodeIds) {
      await serieDoc
          .collection(EPISODES)
          .doc(eid.toString())
          .delete();
    }

    final remaining = await serieDoc.collection(EPISODES).get();
    if (remaining.docs.isEmpty) {
      await serieDoc.delete();
    }
  }

  @override
  Future<List<Series>> getWatchedSeries() async {
    final query = await _watchlistCollection.get();
    final ids = query.docs.map((doc) => int.parse(doc.id)).toList();

    final futures = ids.map((id) async {
      final response = await apiClient.get('$GET_SHOWS/$id');
      return SeriesModel.fromJson(response.data);
    }).toList();

    final seriesList = await Future.wait(futures);
    return seriesList;
  }

  @override
  Future<List<int>> getWatchedEpisodeIds(int serieId) async {
    final seriesDoc = _watchlistCollection.doc(serieId.toString());
    final snap = await seriesDoc.collection(EPISODES).get();
    return snap.docs.map((d) => int.parse(d.id)).toList();
  }
}
