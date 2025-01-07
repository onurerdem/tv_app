class Series {
  final int id;
  final String name;
  final String? imageUrl;
  final String? summary;
  final List<String> genres;
  final String? premiered;
  final String? ended;
  final String? network;
  final String? scheduleTime;
  final List<String> scheduleDays;

  Series({required this.id, required this.name, this.imageUrl, this.summary, required this.genres, this.premiered,
    this.ended, this.network, this.scheduleTime, required this.scheduleDays});
}