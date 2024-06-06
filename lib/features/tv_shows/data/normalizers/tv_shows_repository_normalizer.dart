import 'package:tv_app/core/environment/environment_service.dart';
import 'package:tv_app/core/helpers/html_helper.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/episode_interface.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_schedule_intertface.dart';

class TvShowsRepositoryNormalizer {
  TvShowsRepositoryNormalizer._();

  static ITvShow tvShowFromMap({
    required Map<String, dynamic> mapData,
  }) =>
      ITvShow(
        id: (mapData['id'] as int).toString(),
        name: mapData['name'] as String,
        featuredImageUrl: mapData['image']?['medium'] as String? ??
            mapData['image']?['original'] as String? ??
            EnvironmentService.placeHolderImageUrl,
        description: mapData['summary'] == null
            ? null
            : HtmlHelper.removeAllHtmlTags(mapData['summary'] as String),
        genres: mapData['genres'] != null
            ? List<String>.from(mapData['genres'])
            : [],
        premieredAt: mapData['premiered'] == null
            ? null
            : DateTime.parse(
                mapData['premiered'],
              ),
        endedAt: mapData['ended'] == null
            ? null
            : DateTime.parse(
                mapData['ended'],
              ),
        tvShowSchedule: ITvShowSchedule(
          time: mapData['schedule']?['time'] as String?,
          days: mapData['schedule']?['days'] != null
              ? List<String>.from(mapData['schedule']?['days'])
              : null,
        ),
        network: mapData['network']?['name'] as String?,
        episodes: const [],
      );

  static IEpisode episodeFromMap({
    required Map<String, dynamic> mapData,
  }) =>
      IEpisode(
        id: (mapData['id'] as int).toString(),
        name: mapData['name'] as String,
        description: mapData['summary'] == null
            ? null
            : HtmlHelper.removeAllHtmlTags(mapData['summary'] as String),
        featuredImageUrl: mapData['image']?['medium'] as String? ??
            mapData['image']?['original'] as String? ??
            EnvironmentService.placeHolderImageUrl,
        season: mapData['season'] as int,
        number: mapData['number'] as int,
        airdate: mapData['airdate'] != null
            ? DateTime.tryParse(mapData['airdate'] as String)
            : null,
      );

  static Map<String, dynamic> tvShowToMapData({required ITvShow tvShow}) =>
      <String, dynamic>{
        'id': int.parse(tvShow.id),
        'name': tvShow.name,
        'summary': tvShow.description,
        'genres': tvShow.genres,
        'image': {
          'medium': tvShow.featuredImageUrl,
        },
      };
}