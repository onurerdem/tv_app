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
