class IActor {
  IActor({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.country,
    required this.birthday,
  });

  final String id;
  final String imageUrl;
  final String name;
  final String? country;
  final DateTime? birthday;
}