import 'package:tv_app/features/actors/domain/entities/actor.dart';

class ActorModel extends Actor {
  const ActorModel({
    required super.id,
    required super.fullName,
    super.imageUrl,
    super.country,
    super.birthday,
    super.deathday,
    super.gender,
  });

  factory ActorModel.fromJson(Map<String, dynamic> json) {
    final person = json['person'];
    if (json.containsKey('person')) {
      return ActorModel(
        id: person['id'],
        fullName: person['name'] ?? 'No name',
        imageUrl: person['image'] != null ? person['image']['medium'] : null,
        country: person['country'] != null ? person['country']['name'] : null,
        birthday: person['birthday'] != null
            ? DateTime.tryParse(person['birthday'])
            : null,
        deathday: person['deathday'] != null
            ? DateTime.tryParse(person['deathday'])
            : null,
        gender: person['gender'],
      );
    } else {
      return ActorModel(
        id: json['id'],
        fullName: json['name'] ?? 'No name',
        imageUrl: json['image'] != null ? json['image']['medium'] : null,
        country: json['country'] != null ? json['country']['name'] : null,
        birthday: json['birthday'] != null
            ? DateTime.tryParse(json['birthday'])
            : null,
        deathday: json['deathday'] != null
            ? DateTime.tryParse(json['deathday'])
            : null,
        gender: json['gender'],
      );
    }
  }
}
