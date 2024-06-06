import 'package:equatable/equatable.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/episode_interface.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_schedule_intertface.dart';

class ITvShow extends Equatable {
  const ITvShow({
    required this.id,
    required this.name,
    required this.featuredImageUrl,
    required this.description,
    required this.genres,
    required this.premieredAt,
    required this.endedAt,
    required this.network,
    required this.tvShowSchedule,
    required this.episodes,
  });

  final String id;
  final String name;
  final String featuredImageUrl;
  final String? description;
  final List<String> genres;
  final DateTime? premieredAt;
  final DateTime? endedAt;
  final String? network;
  final ITvShowSchedule? tvShowSchedule;
  final List<IEpisode> episodes;

  ITvShow copyWith({
    List<IEpisode>? episodes,
  }) =>
      ITvShow(
        id: id,
        name: name,
        featuredImageUrl: featuredImageUrl,
        description: description,
        genres: genres,
        premieredAt: premieredAt,
        endedAt: endedAt,
        network: network,
        tvShowSchedule: tvShowSchedule,
        episodes: episodes ?? this.episodes,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        featuredImageUrl,
        description,
        genres,
        premieredAt,
        endedAt,
        network,
        tvShowSchedule,
        episodes,
      ];
}