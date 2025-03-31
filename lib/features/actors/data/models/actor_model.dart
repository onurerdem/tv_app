import 'package:tv_app/features/actors/domain/entities/actor.dart';

class ActorModel extends Actor {
  const ActorModel({
    required super.id,
    required super.fullName,
    super.imageUrl,
    super.country,
    super.birthday,
    super.gender,
  });

  factory ActorModel.fromJson(Map<String, dynamic> json) {
    final person = json['person'];
    return ActorModel(
      id: person['id'],
      fullName: person['name'] ?? 'No name',
      imageUrl: person['image'] != null ? person['image']['medium'] : null,
      country: person['country'] != null ? person['country']['name'] : null,
      birthday: person['birthday'] != null
          ? DateTime.tryParse(person['birthday'])
          : null,
      gender: person['gender'],
    );
  }
}
