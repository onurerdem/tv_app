import 'package:tv_app/core/environment/environment_service.dart';
import 'package:tv_app/features/actors/domain/actor_interface.dart';

class ActorsRepositoryNormalizer {
  ActorsRepositoryNormalizer._();

  static IActor actorFromMap({
    required Map<String, dynamic> mapData,
  }) =>
      IActor(
        id: (mapData['id'] as int).toString(),
        name: mapData['name'] as String,
        imageUrl: mapData['image']?['medium'] as String? ??
            mapData['image']?['original'] as String? ??
            EnvironmentService.placeHolderImageUrl,
        country: mapData['country']?['name'] as String?,
        birthday: mapData['birthday'] != null
            ? DateTime.parse(mapData['birthday'])
            : null,
      );
}