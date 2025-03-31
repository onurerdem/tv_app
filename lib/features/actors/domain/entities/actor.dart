import 'package:equatable/equatable.dart';

class Actor extends Equatable {
  final int id;
  final String fullName;
  final String? imageUrl;
  final String? country;
  final DateTime? birthday;
  final String? gender;

  const Actor({
    required this.id,
    required this.fullName,
    this.imageUrl,
    this.country,
    this.birthday,
    this.gender,
  });

  int? get age {
    if (birthday == null) return null;
    final now = DateTime.now();
    int age = now.year - birthday!.year;
    if (now.month < birthday!.month ||
        (now.month == birthday!.month && now.day < birthday!.day)) {
      age--;
    }
    return age;
  }

  @override
  List<Object?> get props =>
      [id, fullName, imageUrl, country, birthday, gender];
}
