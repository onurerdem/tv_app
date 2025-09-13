part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserEmailAlreadyExists extends UserState {
  @override
  List<Object> get props => [];
}

class UserUsernameAlreadyExists extends UserState {
  @override
  List<Object> get props => [];
}

class EmailVerificationRequired extends UserState {
  @override
  List<Object?> get props => [];
}

class UserVerificationFailed extends UserState {
  final DateTime timestamp; // new
  const UserVerificationFailed(this.timestamp);
  @override
  List<Object?> get props => [timestamp];
}

class UserIsNull extends UserState {
  final DateTime timestamp;
  const UserIsNull(this.timestamp);
  @override
  List<Object> get props => [timestamp];
}

class ResendEmailVerificationSuccess extends UserState {
  final DateTime timestamp;
  const ResendEmailVerificationSuccess(this.timestamp);
  @override
  List<Object?> get props => [timestamp];
}

class ResendEmailVerificationFailure extends UserState {
  final DateTime timestamp;
  const ResendEmailVerificationFailure(this.timestamp);
  @override
  List<Object> get props => [timestamp];
}

class TooManyRequests extends UserState {
  final DateTime timestamp;
  const TooManyRequests(this.timestamp);
  @override
  List<Object?> get props => [timestamp];
}

class ForgotPasswordLoading extends UserState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordFailure extends UserState {
  final String? errorMessage;

  const ForgotPasswordFailure({this.errorMessage});

  @override
  List<Object> get props => [errorMessage ?? ""];
}
