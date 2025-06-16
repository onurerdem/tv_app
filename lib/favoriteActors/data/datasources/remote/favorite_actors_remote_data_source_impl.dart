import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tv_app/core/utils/constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../features/actors/data/models/actor_model.dart';
import '../favorite_actors_remote_data_source.dart';

class FavoriteActorsRemoteDataSourceImpl
    implements FavoriteActorsRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ApiClient apiClient;

  FavoriteActorsRemoteDataSourceImpl(this.auth, this.firestore, this.apiClient);

  @override
  Future<void> addFavoriteActor(ActorModel actor) async {
    final userCollectionRef = firestore.collection(USERS);
    final uid = auth.currentUser!.uid;
    final docRef = userCollectionRef
        .doc(uid)
        .collection(FAVORITE_ACTORS)
        .doc("${actor.id}");
    await docRef.set({});
  }

  @override
  Future<void> removeFavoriteActor(int actorId) async {
    final userCollectionRef = firestore.collection(USERS);
    final uid = auth.currentUser!.uid;
    final docRef =
        userCollectionRef.doc(uid).collection(FAVORITE_ACTORS).doc("$actorId");
    await docRef.delete();
  }

  @override
  Future<List<ActorModel>> getFavoriteActors() async {
    final userCollectionRef = firestore.collection(USERS);
    final uid = auth.currentUser!.uid;
    final querySnapshot = await userCollectionRef.doc(uid).collection(FAVORITE_ACTORS).get();
    final ids = querySnapshot.docs.map((doc) => int.parse(doc.id)).toList();

    final futures = ids.map((id) async {
      final response = await apiClient.get('$GET_ACTORS/$id');
      return ActorModel.fromJson(response.data);
    }).toList();

    final actorsList = await Future.wait(futures);
    return actorsList;
  }
}
