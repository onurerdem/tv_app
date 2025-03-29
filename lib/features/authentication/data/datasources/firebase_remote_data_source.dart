import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<String> getCurrentUId();
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> forgotPassword(String emailOrUsername);
  Future<Map<String, dynamic>> getUserProfile(String uid);
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity user);
  Future<void> changePassword(String oldPassword, String newPassword);
}
