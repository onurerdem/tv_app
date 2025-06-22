import 'package:equatable/equatable.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlist extends WatchlistEvent {
  @override
  List<Object?> get props => [];
}

class SearchSerieInWatchlist extends WatchlistEvent {
  final String query;
  const SearchSerieInWatchlist(this.query);

  @override
  List<Object?> get props => [query];
}

class AddSerieToWatchlist extends WatchlistEvent {
  final Series serie;
  const AddSerieToWatchlist(this.serie);

  @override
  List<Object?> get props => [serie];
}

class RemoveSerieFromWatchlist extends WatchlistEvent {
  final Series serie;
  const RemoveSerieFromWatchlist(this.serie);

  @override
  List<Object?> get props => [serie];
}
