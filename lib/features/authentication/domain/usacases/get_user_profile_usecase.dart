import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/features/authentication/domain/entities/user_entity.dart';
import '../repositories/firebase_repository.dart';
import 'package:tv_app/core/usecase/usecase.dart';

class GetUserProfileUseCase implements UseCase<UserEntity, NoParams> {
  final FirebaseRepository repository;

  GetUserProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
