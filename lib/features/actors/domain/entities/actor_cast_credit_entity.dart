import 'package:equatable/equatable.dart';

class ActorCastCreditEntity extends Equatable {
  final String serieName;
  final String? characterName;
  final String? imageUrl;
  final int serieId;

  const ActorCastCreditEntity({
    required this.serieName,
    this.characterName,
    this.imageUrl,
    required this.serieId,
  });

  @override
  List<Object?> get props => [serieName, characterName, imageUrl, serieId];
}
