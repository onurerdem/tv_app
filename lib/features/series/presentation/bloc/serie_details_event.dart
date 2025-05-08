import 'package:equatable/equatable.dart';

abstract class SerieDetailsEvent extends Equatable {
  const SerieDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetSerieDetailsEvent extends SerieDetailsEvent {
  final int serieId;

  const GetSerieDetailsEvent(this.serieId);

  @override
  List<Object?> get props => [serieId];
}

class SelectSeasonEvent extends SerieDetailsEvent {
  final int? season;

  const SelectSeasonEvent(this.season);

  @override
  List<Object?> get props => [season];
}
