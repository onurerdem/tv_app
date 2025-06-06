import 'package:tv_app/features/actors/domain/entities/actor_cast_credit_entity.dart';

import '../../../series/data/models/series_model.dart';
import '../../../series/domain/entities/series.dart';

class ActorCastCreditModel extends ActorCastCreditEntity {
  const ActorCastCreditModel({
    required super.serie,
    required super.serieName,
    required super.characterName,
    required super.imageUrl,
    required super.serieId,
  });

  factory ActorCastCreditModel.fromJson(Map<String, dynamic> json) {
    final character = json['_links']?['character'];

    final embeddedShow = json['_embedded']?['show'];

    final Series serie = embeddedShow != null
        ? SeriesModel.fromJson(embeddedShow)
        : throw Exception("Missing show info");

    return ActorCastCreditModel(
      serie: serie,
      serieName: embeddedShow?['name'] ?? 'Unknown Serie.',
      characterName: character?['name'],
      imageUrl: embeddedShow?['image']?['medium'],
      serieId: embeddedShow?['id'] ?? 0,
    );
  }
}
