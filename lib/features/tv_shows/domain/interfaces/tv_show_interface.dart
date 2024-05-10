class ITvShow {
  ITvShow({
    required this.id,
    required this.name,
    required this.featuredImageUrl,
    required this.summary,
    required this.genres,
    required this.premieredAt,
    required this.endedAt,
  });

  final String id;
  final String name;
  final String featuredImageUrl;
  final String summary;
  final List<String> genres;
  final DateTime premieredAt;
  final DateTime endedAt;
}