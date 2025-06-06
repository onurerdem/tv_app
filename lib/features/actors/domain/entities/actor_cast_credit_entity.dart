import 'package:equatable/equatable.dart';

import '../../../series/domain/entities/series.dart';

class ActorCastCreditEntity extends Equatable {
  final Series serie;
  final String serieName;
  final String? characterName;
  final String? imageUrl;
  final int serieId;

  const ActorCastCreditEntity({
    required this.serie,
    required this.serieName,
    this.characterName,
    this.imageUrl,
    required this.serieId,
  });

  @override
  List<Object?> get props => [serie, serieName, characterName, imageUrl, serieId];
}
