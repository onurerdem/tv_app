import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants.dart';
import '../../../domain/entities/user_entity.dart';
import '../../models/user_model.dart';
import '../firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseRemoteDataSourceImpl({required this.auth, required this.firestore});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollectionRef = firestore.collection(USERS);
    final uid = await getCurrentUId();
    userCollectionRef.doc(uid).get().then((value) {
      final newUser = UserModel(
        uid: uid,
        status: user.status,
        email: user.email,
        name: user.name,
        username: user.username,
      ).toDocument();
      if (!value.exists) {
        userCollectionRef.doc(uid).set(newUser);
      }
      return;
    });
  }

  @override
  Future<String> getCurrentUId() async => auth.currentUser!.uid;

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signIn(UserEntity user) async {
    String email;

    if (user.username!.contains('@')) {
      email = user.username!;
    } else {
      email = await _getEmailFromUsername(user.username!, firestore);
    }

    await auth.signInWithEmailAndPassword(
      email: email,
      password: user.password!,
    );
  }

  @override
  Future<void> signOut() async => auth.signOut();

  @override
  Future<void> signUp(UserEntity user) async =>
      auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

  @override
  Future<void> forgotPassword(String emailOrUsername) async {
    String email;

    if (emailOrUsername.contains('@')) {
      email = emailOrUsername;
    } else {
      email = await _getEmailFromUsername(emailOrUsername, firestore);
    }

    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(String uid) async {
    final doc = await firestore.collection(USERS).doc(uid).get();
    if (doc.exists) {
      return doc.data()!;
    } else {
      throw Exception("User profile not found.");
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity user) async {
    try {
      final uid = await getCurrentUId();
      final userCollection = firestore.collection(USERS);
      final updatedData = UserModel(
        uid: uid,
        name: user.name,
        username: user.username,
        email: user.email,
        status: user.status,
      ).toDocument();
      await userCollection.doc(uid).update(updatedData);
      final updatedDoc = await userCollection.doc(uid).get();
      return Right(UserModel.fromSnapshot(updatedDoc));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception("No user signed in!");
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      debugPrint(
          "FirebaseAuthException caught: code=${e.code}, message=${e.message}");
      if (e.code == "wrong-password" || e.code == "invalid-credential") {
        throw OldPasswordWrongFailure();
      } else if (e.code == "weak-password") {
        throw Exception("Password should be at least 6 characters.");
      } else {
        throw Exception("Failed to update password.");
      }
    }
  }
}

Future<String> _getEmailFromUsername(
  String username,
  FirebaseFirestore firestore,
) async {
  final QuerySnapshot snapshot = await firestore
      .collection(USERS)
      .where('username', isEqualTo: username)
      .get();

  return snapshot.docs.first.get('email');
}

Future<bool> isTheUsernameAvailable(String username) async {
  try {
    final usernameDoc = await FirebaseFirestore.instance
        .collection(USERS)
        .where('username', isEqualTo: username)
        .get();
    return usernameDoc.docs.isNotEmpty;
  } catch (e) {
    if (kDebugMode) {
      print("Username check error: $e");
    }
    return false;
  }
}

Future<bool> isTheEmailRegistered(String email) async {
  try {
    final emailDoc = await FirebaseFirestore.instance
        .collection(USERS)
        .where('email', isEqualTo: email)
        .get();
    return emailDoc.docs.isNotEmpty;
  } catch (e) {
    if (kDebugMode) {
      print("Email registration check error: $e");
    }
    return false;
  }
}
