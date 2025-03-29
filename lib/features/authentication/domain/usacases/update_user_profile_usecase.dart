import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import 'package:tv_app/features/authentication/domain/entities/user_entity.dart';
import 'package:tv_app/features/authentication/domain/repositories/firebase_repository.dart';

class UpdateUserProfileUseCase implements UseCase<UserEntity, UserEntity> {
  final FirebaseRepository repository;

  UpdateUserProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity params) async {
    return await repository.updateUserProfile(params);
  }
}
