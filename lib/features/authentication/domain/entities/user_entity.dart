import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? name;
  final String? username;
  final String? email;
  final String? uid;
  final String? status;
  final String? password;

  const UserEntity({
    this.name = "Empty",
    this.username,
    this.email,
    this.uid,
    this.status = "Hello there! I'm using this app.",
    this.password,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    username,
    email,
    uid,
    status,
    password,
  ];
}
