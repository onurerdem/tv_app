import 'package:tv_app/features/series/domain/entities/series.dart';

class SeriesModel extends Series {
  SeriesModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.summary,
    required super.genres,
    super.premiered,
    super.ended,
    super.network,
    super.scheduleTime,
    required super.scheduleDays,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('show')) {
      return SeriesModel(
        id: json['show']['id'],
        name: json['show']['name'],
        imageUrl: json['show']['image'] != null ? json['show']['image']['medium'] : null,
        summary: json['show']['summary'] ?? 'Explanation not available.',
        genres: List<String>.from(json['show']['genres'] ?? []),
        premiered: json['show']['premiered'],
        ended: json['show']['ended'],
        network: json['show']['network']?['name'] ?? 'Network not available.',
        scheduleTime: json['show']['schedule']?['time'] ?? 'Time not available.',
        scheduleDays: List<String>.from(json['show']['schedule']?['days'] ?? []),
      );
    } else {
      return SeriesModel(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image'] != null ? json['image']['medium'] : null,
        summary: json['summary'] ?? 'Explanation not available.',
        genres: List<String>.from(json['genres'] ?? []),
        premiered: json['premiered'],
        ended: json['ended'],
        network: json['network']?['name'] ?? 'Network not available.',
        scheduleTime: json['schedule']?['time'] ?? 'Time not available.',
        scheduleDays: List<String>.from(json['schedule']?['days'] ?? []),
      );
    }
  }
}