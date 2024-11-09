import 'package:tv_app/features/series/domain/entities/series.dart';

class SeriesModel extends Series {
  SeriesModel({
    required int id,
    required String name,
    String? imageUrl,
  }) : super(id: id, name: name, imageUrl: imageUrl);

  factory SeriesModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('show')) {
      return SeriesModel(
        id: json['show']['id'],
        name: json['show']['name'],
        imageUrl: json['show']['image'] != null ? json['show']['image']['medium'] : null,
      );
    } else {
      return SeriesModel(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image'] != null ? json['image']['medium'] : null,
      );
    }
  }
}