import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';
import '../../domain/usecases/add_to_watchlist.dart';
import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/remove_from_watchlist.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlist getWatchlist;
  final AddToWatchlist addToWatchlist;
  final RemoveFromWatchlist removeFromWatchlist;

  List<Series> _allWatchlist = [];
  List<Series> _filteredWatchlist = [];

  WatchlistBloc(
      this.getWatchlist,
      this.addToWatchlist,
      this.removeFromWatchlist,
      ) : super(WatchlistInitial()) {
    on<LoadWatchlist>((event, emit) async {
      if (state is WatchlistLoading) return;

      emit(WatchlistLoading());

      final result = await getWatchlist();

      result.fold(
            (failure) {
          emit(WatchlistError("Cannot load watchlist."));
        },
            (watchlist) {
          _allWatchlist = watchlist;
          _filteredWatchlist = watchlist;

          final watchlistIds = watchlist.map((s) => s.id).toList();

          final dummySerie = Series(
            id: -1,
            name: "",
            summary: "",
            imageUrl: null,
            ratingAverage: null,
            genres: [],
            scheduleDays: [],
            scheduleTime: null,
            premiered: null,
            ended: null,
          );

          emit(WatchlistLoaded(
            watchlistIds,
            dummySerie,
            allWatchList: _allWatchlist,
            filteredWatchList: _filteredWatchlist,
          ));
        },
      );
    });

    on<SearchSerieInWatchlist>((event, emit) async {
      if (state is WatchlistLoading) return;

      emit(WatchlistLoading());

      final result = await getWatchlist();

      result.fold(
            (failure) {
          emit(WatchlistError(
            "Failed to load watchlist.",
          ));
        },
            (watchlist) {
          _allWatchlist = watchlist;

          final serieIds = watchlist.map((s) => s.id).toList();

          final dummySerie = Series(
            id: -1,
            name: "",
            summary: "",
            imageUrl: null,
            ratingAverage: null,
            genres: [],
            //network: null,
            scheduleDays: [],
            scheduleTime: null,
            premiered: null,
            ended: null,
          );

          final query = event.query.trim().toLowerCase();
          if (query.isEmpty) {
            _filteredWatchlist = _allWatchlist;
          } else {
            _filteredWatchlist = _allWatchlist.where((serie) {
              return serie.name.toLowerCase().contains(query);
            }).toList();
          }

          emit(WatchlistLoaded(
            serieIds,
            dummySerie,
            allWatchList: _filteredWatchlist,
            filteredWatchList: _filteredWatchlist,
          ));
        },
      );
    });

    on<AddSerieToWatchlist>((event, emit) async {
      final currentState = state;
      if (currentState is WatchlistLoaded) {
        if (currentState.serieIds.contains(event.serie.id)) {
          return;
        }

        final updatedWatchlist = List<Series>.from(currentState.allWatchList)
          ..add(event.serie);
        final updatedIds = updatedWatchlist.map((s) => s.id).toList();

        final result = await addToWatchlist(event.serie.id);
        result.fold(
              (failure) {
            final revertedWatchlist =
            List<Series>.from(currentState.allWatchList);
            final revertedIds = revertedWatchlist.map((s) => s.id).toList();
            emit(WatchlistLoaded(
              revertedIds,
              event.serie,
              allWatchList: revertedWatchlist,
              filteredWatchList: revertedWatchlist,
            ));
            emit(WatchlistError("Failed to add to watchlist."));
          },
              (_) {
            emit(WatchlistLoaded(
              updatedIds,
              event.serie,
              allWatchList: updatedWatchlist,
              filteredWatchList: updatedWatchlist,
            ));
          },
        );
      }
    });

    on<RemoveSerieFromWatchlist>((event, emit) async {
      final currentState = state;
      if (currentState is WatchlistLoaded) {
        if (!currentState.serieIds.contains(event.serie.id)) {
          return;
        }

        final updatedWatchlist = List<Series>.from(currentState.allWatchList)
          ..removeWhere((s) => s.id == event.serie.id);
        final updatedIds = updatedWatchlist.map((s) => s.id).toList();

        final result = await removeFromWatchlist(event.serie.id);
        result.fold(
              (failure) {
            final revertedWatchlist =
            List<Series>.from(currentState.allWatchList);
            final revertedIds = revertedWatchlist.map((s) => s.id).toList();
            emit(WatchlistLoaded(
              revertedIds,
              event.serie,
              allWatchList: revertedWatchlist,
              filteredWatchList: revertedWatchlist,
            ));
            emit(WatchlistError("Failed to remove from watchlist."));
          },
              (_) {
            emit(WatchlistLoaded(
              updatedIds,
              event.serie,
              allWatchList: updatedWatchlist,
              filteredWatchList: updatedWatchlist,
            ));
          },
        );
      }
    });
  }
}
