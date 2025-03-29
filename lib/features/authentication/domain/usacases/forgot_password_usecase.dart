import '../repositories/firebase_repository.dart';

class ForgotPasswordUseCase {
  final FirebaseRepository repository;

  ForgotPasswordUseCase({required this.repository});

  Future<void> call(String emailOrUsername) async {
    return await repository.forgotPassword(emailOrUsername);
  }
}