import 'package:tv_app/features/actors/domain/entities/actor_cast_credit_entity.dart';

class ActorCastCreditModel extends ActorCastCreditEntity {
  const ActorCastCreditModel({
    required super.serieName,
    required super.characterName,
    required super.imageUrl,
    required super.serieId,
  });

  factory ActorCastCreditModel.fromJson(Map<String, dynamic> json) {
    final serie = json['_links']?['show'];
    final character = json['_links']?['character'];
    final imageUrl = json['_embedded']?['show'];
    final serieId = json['_embedded']?['show'];
    return ActorCastCreditModel(
      serieName: serie?['name'] ?? 'Unknown Serie',
      characterName: character?['name'],
      imageUrl: imageUrl?['image']['medium'],
      serieId: serieId['id'],
    );
  }
}
