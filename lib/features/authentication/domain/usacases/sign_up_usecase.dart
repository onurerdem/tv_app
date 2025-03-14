import '../entities/user_entity.dart';
import '../repositories/firebase_repository.dart';

class SignUpUseCase {

  final FirebaseRepository repository;

  SignUpUseCase({required this.repository});

  Future<void> call(UserEntity user) async {
    return repository.signUp(user);
  }
}