import 'package:dartz/dartz.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import 'package:tv_app/features/authentication/domain/repositories/firebase_repository.dart';

class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final FirebaseRepository repository;
  ChangePasswordUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return await repository.changePassword(params.oldPassword, params.newPassword);
  }
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;

  ChangePasswordParams({required this.oldPassword, required this.newPassword});
}
