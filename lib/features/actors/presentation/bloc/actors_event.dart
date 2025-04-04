import 'package:equatable/equatable.dart';

abstract class ActorsEvent extends Equatable {
  const ActorsEvent();

  @override
  List<Object?> get props => [];
}

class GetAllActorsEvent extends ActorsEvent {}

class SearchActorsQueryEvent extends ActorsEvent {
  final String query;

  const SearchActorsQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}
