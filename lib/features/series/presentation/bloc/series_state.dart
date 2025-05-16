import 'package:equatable/equatable.dart';

import '../../domain/entities/series.dart';

abstract class SeriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SeriesInitial extends SeriesState {}

class SeriesLoading extends SeriesState {}

class SeriesLoaded extends SeriesState {
  final List<Series> seriesList;
  final bool hasReachedMax;

  SeriesLoaded(this.seriesList, this.hasReachedMax);

  @override
  List<Object?> get props => [seriesList, hasReachedMax];
}

class SeriesError extends SeriesState {
  final String message;

  SeriesError(this.message);

  @override
  List<Object?> get props => [message];
}
