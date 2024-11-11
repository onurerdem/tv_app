import 'package:equatable/equatable.dart';

abstract class SeriesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAllSeriesEvent extends SeriesEvent {}

class SearchSeriesQuery extends SeriesEvent {
  final String query;

  SearchSeriesQuery(this.query);

  @override
  List<Object> get props => [query];
}
