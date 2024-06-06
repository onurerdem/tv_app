import 'package:equatable/equatable.dart';

class IEpisode extends Equatable {
  const IEpisode({
    required this.id,
    required this.name,
    required this.description,
    required this.featuredImageUrl,
    required this.season,
    required this.number,
    required this.airdate,
  });

  final String id;
  final String name;
  final String? description;
  final String featuredImageUrl;
  final int season;
  final int number;
  final DateTime? airdate;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        featuredImageUrl,
        season,
        number,
        airdate,
      ];
}