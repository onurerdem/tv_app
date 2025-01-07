import 'package:equatable/equatable.dart';

import '../../domain/entities/series.dart';

abstract class SerieDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SerieDetailsInitial extends SerieDetailsState {}

class SerieDetailsLoading extends SerieDetailsState {}

class SerieDetailsLoaded extends SerieDetailsState {
  final Series serieDetails;

  SerieDetailsLoaded(this.serieDetails);

  @override
  List<Object?> get props => [serieDetails];
}

class SerieDetailsError extends SerieDetailsState {
  final String message;

  SerieDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
