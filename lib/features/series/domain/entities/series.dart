class Series {
  final int id;
  final String name;
  final String? language;
  final List<String> genres;
  final int? runtime;
  final int? averageRuntime;
  final String? premiered;
  final String? ended;
  final String? officialSite;
  final String? scheduleTime;
  final List<String> scheduleDays;
  final double? ratingAverage;
  final String? networkName;
  final String? networkCountryName;
  final String? imageUrl;
  final String? summary;

  Series({
    required this.id,
    required this.name,
    this.language,
    required this.genres,
    this.runtime,
    this.averageRuntime,
    this.premiered,
    this.ended,
    this.officialSite,
    this.scheduleTime,
    required this.scheduleDays,
    this.ratingAverage,
    this.networkName,
    this.networkCountryName,
    this.imageUrl,
    this.summary,
  });
}
