import 'package:equatable/equatable.dart';

class Actor extends Equatable {
  final int id;
  final String fullName;
  final String? imageUrl;
  final String? country;
  final DateTime? birthday;
  final DateTime? deathday;
  final String? gender;

  const Actor({
    required this.id,
    required this.fullName,
    this.imageUrl,
    this.country,
    this.birthday,
    this.deathday,
    this.gender,
  });

  int? get age {
    if (birthday == null) return null;
    final now = DateTime.now();
    int? age;
    if (deathday == null) {
      age = now.year - birthday!.year;
      if (now.month < birthday!.month ||
          (now.month == birthday!.month && now.day < birthday!.day)) {
        age--;
      }
    } else {
      age = deathday!.year - birthday!.year;
      if (deathday!.month < birthday!.month ||
          (deathday!.month == birthday!.month && deathday!.day < birthday!.day)) {
        age--;
      }
    }
    return age;
  }

  @override
  List<Object?> get props => [id, fullName, imageUrl, country, birthday, deathday, gender];
}
