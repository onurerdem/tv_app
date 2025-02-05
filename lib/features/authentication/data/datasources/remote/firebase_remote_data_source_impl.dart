import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/user_entity.dart';
import '../../models/user_model.dart';
import '../firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseRemoteDataSourceImpl({required this.auth, required this.firestore});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async{
    final userCollectionRef = firestore.collection("Users");
    final uid=await getCurrentUId();
    userCollectionRef.doc(uid).get().then((value){
      final newUser=UserModel(
        uid: uid ,
        status: user.status,
        email: user.email,
        name: user.name,
      ).toDocument();
      if (!value.exists){
        userCollectionRef.doc(uid).set(newUser);
      }
      return;
    });

  }

  @override
  Future<String> getCurrentUId() async => auth.currentUser!.uid;

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid !=null;

  @override
  Future<void> signIn(UserEntity user) async =>
      auth.signInWithEmailAndPassword(email: user.email!, password: user.password!);

  @override
  Future<void> signOut()  async =>
      auth.signOut();

  @override
  Future<void> signUp(UserEntity user) async =>
      auth.createUserWithEmailAndPassword(email: user.email!, password: user.password!);
}