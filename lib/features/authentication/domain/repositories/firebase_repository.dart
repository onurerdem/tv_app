import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<String> getCurrentUId();
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> forgotPassword(String emailOrUsername);
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity user);
  Future<Either<Failure, void>> changePassword(String oldPassword, String newPassword);
}
