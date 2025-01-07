import 'package:equatable/equatable.dart';

abstract class SerieDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetSerieDetailsEvent extends SerieDetailsEvent {
  final int serieId;

  GetSerieDetailsEvent(this.serieId);

  @override
  List<Object?> get props => [serieId];
}
