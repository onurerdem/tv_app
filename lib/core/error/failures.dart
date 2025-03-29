abstract class Failure {
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class OldPasswordWrongFailure extends Failure {
  @override
  String toString() => "You entered your old password incorrectly!";
}