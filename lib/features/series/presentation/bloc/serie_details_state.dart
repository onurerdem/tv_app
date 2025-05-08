import 'package:equatable/equatable.dart';
import 'package:tv_app/features/series/domain/entities/episode.dart';
import '../../domain/entities/series.dart';

abstract class SerieDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SerieDetailsInitial extends SerieDetailsState {}

class SerieDetailsLoading extends SerieDetailsState {}

class SerieDetailsLoaded extends SerieDetailsState {
  final Series serieDetails;
  final List<Episode> allEpisodes;
  final int? selectedSeason;

  SerieDetailsLoaded(
    this.serieDetails,
    this.allEpisodes, {
    this.selectedSeason,
  });

  SerieDetailsLoaded copyWith({
    Series? serieDetails,
    List<Episode>? allEpisodes,
    int? selectedSeason,
    bool forceSelectedSeasonNull = false,
  }) {
    return SerieDetailsLoaded(
      serieDetails ?? this.serieDetails,
      allEpisodes ?? this.allEpisodes,
      selectedSeason: forceSelectedSeasonNull
          ? null
          : selectedSeason ?? this.selectedSeason,
    );
  }

  List<int> get availableSeasons {
    if (allEpisodes.isEmpty) return [];
    final seasons = allEpisodes.map((ep) => ep.season).toSet().toList();
    seasons.sort();
    return seasons;
  }

  List<Episode> get filteredEpisodes {
    if (selectedSeason == null) {
      return allEpisodes;
    }
    return allEpisodes.where((ep) => ep.season == selectedSeason).toList();
  }

  @override
  List<Object?> get props => [serieDetails, allEpisodes, selectedSeason];
}

class SerieDetailsError extends SerieDetailsState {
  final String message;

  SerieDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
