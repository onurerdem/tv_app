import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/firebase_repository.dart';
import '../datasources/firebase_remote_data_source.dart';
import '../models/user_model.dart';

class FirebaseRepositoryImpl extends FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUId() async => remoteDataSource.getCurrentUId();

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signIn(UserEntity user) async => remoteDataSource.signIn(user);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUp(UserEntity user) async => remoteDataSource.signUp(user);

  @override
  Future<void> forgotPassword(String emailOrUsername) async {
    remoteDataSource.forgotPassword(emailOrUsername);
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final uid = await remoteDataSource.getCurrentUId();
      final data = await remoteDataSource.getUserProfile(uid);
      return Right(UserModel(
        uid: data['uid'],
        name: data['name'],
        email: data['email'],
        username: data['username'],
        status: data['status'],
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
