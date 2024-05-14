import 'package:tv_app/core/helpers/html_helper.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

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
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
        summary: HtmlHelper.removeAllHtmlTags(mapData['summary'] as String),
        genres: List<String>.from(mapData['genres']),
        premieredAt: DateTime.parse(
          mapData['premiered'],
        ),
        endedAt: mapData['ended'] == null
            ? null
            : DateTime.parse(
                mapData['ended'],
              ),
      );
}