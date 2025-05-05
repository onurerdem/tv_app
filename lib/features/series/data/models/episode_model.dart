import '../../domain/entities/episode.dart';

class EpisodeModel extends Episode {
  EpisodeModel({
    required super.id,
    required super.name,
    required super.season,
    required super.number,
    required super.airdate,
    required super.airtime,
    required super.runtime,
    required super.ratingAverage,
    required super.imageUrl,
    required super.summary,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    String? mediumImageUrl;
    if (json['image'] != null && json['image'] is Map<String, dynamic>) {
      mediumImageUrl = json['image']['medium'] as String?;
    }

    double? ratingAverage;
    if (json['rating'] != null && json['rating'] is Map) {
      final avgValue = json['rating']['average'];
      if (avgValue != null && avgValue is num) {
        ratingAverage = avgValue.toDouble();
      }
    }

    return EpisodeModel(
      id: json['id'],
      name: json['name'],
      season: json['season'],
      number: json['number'] as int?,
      airdate: json['airdate'] as String?,
      airtime: json['airtime'] as String?,
      runtime: json['runtime'] as int?,
      ratingAverage: ratingAverage,
      imageUrl: mediumImageUrl,
      summary: json['summary'],
    );
  }
}
