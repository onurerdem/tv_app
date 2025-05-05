class Episode {
  final int id;
  final String? name;
  final int season;
  final int? number;
  final String? airdate;
  final String? airtime;
  final int? runtime;
  final double? ratingAverage;
  final String? imageUrl;
  final String? summary;

  Episode({
    required this.id,
    required this.name,
    required this.season,
    required this.number,
    required this.airdate,
    required this.airtime,
    required this.runtime,
    required this.ratingAverage,
    required this.imageUrl,
    required this.summary,
  });
}
