import 'package:equatable/equatable.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';

abstract class WatchlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<int> serieIds;
  final List<Series> allWatchList;
  final List<Series> filteredWatchList;
  final Series serie;

  WatchlistLoaded(
      this.serieIds,
      this.serie, {
        required this.allWatchList,
        required this.filteredWatchList,
      });

  @override
  List<Object?> get props => [serieIds, allWatchList, filteredWatchList, serie];
}

class WatchlistError extends WatchlistState {
  final String message;
  WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}
