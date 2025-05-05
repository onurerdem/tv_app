import 'package:tv_app/features/series/domain/entities/series.dart';

class SeriesModel extends Series {
  SeriesModel({
    required super.id,
    required super.name,
    super.language,
    required super.genres,
    super.runtime,
    super.averageRuntime,
    super.premiered,
    super.ended,
    super.officialSite,
    super.scheduleTime,
    required super.scheduleDays,
    super.ratingAverage,
    super.networkName,
    super.networkCountryName,
    super.imageUrl,
    super.summary,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json) {
    double? _parseRating(Map<String, dynamic>? ratingData) {
      if (ratingData != null) {
        final avgValue = ratingData['average'];
        if (avgValue != null && avgValue is num) {
          return avgValue.toDouble();
        }
      }
      return null;
    }

    if (json.containsKey('show')) {
      return SeriesModel(
        id: json['show']['id'],
        name: json['show']['name'],
        language: json['show']['language'],
        genres: List<String>.from(json['show']['genres'] ?? []),
        runtime: json['show']['runtime'],
        averageRuntime: json['show']['averageRuntime'],
        premiered: json['show']['premiered'],
        ended: json['show']['ended'],
        officialSite: json['show']['officialSite'],
        scheduleTime: json['show']['schedule']?['time'] ?? 'Time not available.',
        scheduleDays: List<String>.from(json['show']['schedule']?['days'] ?? []),
        ratingAverage: _parseRating(json['show']['rating'] as Map<String, dynamic>?),
        networkName: json['show']['network']?['name'] ?? 'Network not available.',
        networkCountryName: json['show']['network']?['country']?['name'] ?? 'Country not available.',
        imageUrl: json['show']['image'] != null ? json['show']['image']['medium'] : null,
        summary: json['show']['summary'] ?? 'Explanation not available.',
      );
    } else {
      return SeriesModel(
        id: json['id'],
        name: json['name'],
        language: json['language'],
        genres: List<String>.from(json['genres'] ?? []),
        runtime: json['runtime'],
        averageRuntime: json['averageRuntime'],
        premiered: json['premiered'],
        ended: json['ended'],
        officialSite: json['officialSite'],
        scheduleTime: json['schedule']?['time'] ?? 'Time not available.',
        scheduleDays: List<String>.from(json['schedule']?['days'] ?? []),
        ratingAverage: _parseRating(json['rating'] as Map<String, dynamic>?),
        networkName: json['network']?['name'] ?? 'Network not available.',
        networkCountryName: json['network']?['country']?['name'] ?? 'Country not available.',
        imageUrl: json['image'] != null ? json['image']['medium'] : null,
        summary: json['summary'] ?? 'Explanation not available.',
      );
    }
  }
}