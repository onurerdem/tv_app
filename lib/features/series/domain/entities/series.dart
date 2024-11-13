class Series {
  final int id;
  final String name;
  final String? imageUrl;
  final String? summary;
  final List<String> genres;

  Series({required this.id, required this.name, this.imageUrl, this.summary, required this.genres});
}