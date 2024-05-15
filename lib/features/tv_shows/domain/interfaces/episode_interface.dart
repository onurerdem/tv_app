class IEpisode {
  IEpisode({
    required this.id,
    required this.name,
    required this.description,
    required this.featuredImageUrl,
    required this.season,
    required this.number,
  });

  final String id;
  final String name;
  final String? description;
  final String featuredImageUrl;
  final int season;
  final int number;
}