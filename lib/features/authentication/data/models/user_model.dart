import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  const UserModel({
    super.name,
    super.username,
    super.email,
    super.uid,
    super.status = null,
    super.password,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot documentSnapshot){
    return UserModel(
      status: documentSnapshot.get('status'),
      name: documentSnapshot.get('name'),
      uid: documentSnapshot.get('uid'),
      email: documentSnapshot.get('email'),
      username: documentSnapshot.get('username'),
    );
  }

  Map<String,dynamic> toDocument(){
    return {
      "status": status,
      "uid": uid,
      "email": email,
      "name": name,
      "username": username,
    };
  }

}