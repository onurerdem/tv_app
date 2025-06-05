import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import 'package:tv_app/features/serie_favorites/domain/usecases/fetch_favorite_series_details.dart';
import 'package:tv_app/features/serie_favorites/domain/usecases/get_favorite_series.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../../domain/usecases/get_favorites.dart';

part 'serie_favorites_event.dart';
part 'serie_favorites_state.dart';

class SerieFavoritesBloc
    extends Bloc<SerieFavoritesEvent, SerieFavoritesState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final FetchFavoriteSeriesDetails fetchFavoriteSeriesDetails;
  final GetFavoriteSeries getFavoriteSeries;

  List<Series> _allFavorites = [];
  List<Series> _filteredFavorites = [];

  SerieFavoritesBloc(
    this.getFavorites,
    this.addFavorite,
    this.removeFavorite,
    this.fetchFavoriteSeriesDetails,
    this.getFavoriteSeries,
  ) : super(SerieFavoritesInitial()) {
    on<LoadSerieFavorites>((event, emit) async {
      if (state is SerieFavoritesLoading) return;

      emit(SerieFavoritesLoading());

      final result = await getFavoriteSeries(NoParams());

      result.fold(
        (failure) {
          if (kDebugMode) {
            print("LoadSerieFavorites Error: ${failure.toString()}");
          }
          emit(SerieFavoritesError(
            "Failed to load favorites.",
          ));
        },
        (favoritesList) {
          _allFavorites = favoritesList;
          _filteredFavorites = favoritesList;

          final favoriteIds = favoritesList.map((s) => s.id).toList();

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

          emit(
            SerieFavoritesLoaded(
              favoriteIds,
              dummySerie,
              allFavorites: _allFavorites,
              filteredFavorites: _filteredFavorites,
            ),
          );

          if (kDebugMode) {
            print("Favorites loaded: $favoritesList");
          }
        },
      );
    });

    on<SearchSerieFavorites>((event, emit) async {
      if (state is SerieFavoritesLoading) return;

      emit(SerieFavoritesLoading());

      final result = await getFavoriteSeries(NoParams());

      result.fold(
        (failure) {
          if (kDebugMode) {
            print("LoadSerieFavorites Error: ${failure.toString()}");
          }
          emit(SerieFavoritesError(
            "Failed to load favorites.",
          ));
        },
        (favoritesList) {
          _allFavorites = favoritesList;

          final favoriteIds = favoritesList.map((s) => s.id).toList();

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

          final query = event.query.trim().toLowerCase();
          if (query.isEmpty) {
            _filteredFavorites = _allFavorites;
          } else {
            _filteredFavorites = _allFavorites.where((serie) {
              return serie.name.toLowerCase().contains(query);
            }).toList();
          }

          emit(
            SerieFavoritesLoaded(
              favoriteIds,
              dummySerie,
              allFavorites: _filteredFavorites,
              filteredFavorites: _filteredFavorites,
            ),
          );

          if (kDebugMode) {
            print("Favorites loaded: $favoritesList");
          }
        },
      );
    });

    on<AddSerieToFavorites>((event, emit) async {
      final currentState = state;
      if (currentState is SerieFavoritesLoaded) {
        if (currentState.favoriteIds.contains(event.serie.id)) {
          return;
        }

        final updatedFavorites = List<Series>.from(currentState.allFavorites)
          ..add(event.serie);
        final updatedIds = updatedFavorites.map((s) => s.id).toList();

        final result = await addFavorite(event.serie.id);
        result.fold(
          (failure) {
            final revertedFavorites =
                List<Series>.from(currentState.allFavorites);
            final revertedIds = revertedFavorites.map((s) => s.id).toList();
            emit(
              SerieFavoritesLoaded(
                revertedIds,
                event.serie,
                allFavorites: revertedFavorites,
                filteredFavorites: revertedFavorites,
              ),
            );
            emit(const SerieFavoritesError("Failed to add to favorites."));
          },
          (_) {
            if (kDebugMode) {
              print("Added to favorites: ${event.serie.id}");
            }
            emit(
              SerieFavoritesLoaded(
                updatedIds,
                event.serie,
                allFavorites: updatedFavorites,
                filteredFavorites: updatedFavorites,
              ),
            );
          },
        );
      }
    });

    on<RemoveSerieFromFavorites>((event, emit) async {
      final currentState = state;
      if (currentState is SerieFavoritesLoaded) {
        if (!currentState.favoriteIds.contains(event.serie.id)) {
          return;
        }

        final updatedFavorites = List<Series>.from(currentState.allFavorites)
          ..removeWhere((s) => s.id == event.serie.id);
        final updatedIds = updatedFavorites.map((s) => s.id).toList();

        final result = await removeFavorite(event.serie.id);
        result.fold(
          (failure) {
            final revertedFavorites =
                List<Series>.from(currentState.allFavorites);
            final revertedIds = revertedFavorites.map((s) => s.id).toList();
            emit(
              SerieFavoritesLoaded(
                revertedIds,
                event.serie,
                allFavorites: revertedFavorites,
                filteredFavorites: revertedFavorites,
              ),
            );
            emit(const SerieFavoritesError("Failed to remove from favorites."));
          },
          (_) {
            emit(
              SerieFavoritesLoaded(
                updatedIds,
                event.serie,
                allFavorites: updatedFavorites,
                filteredFavorites: updatedFavorites,
              ),
            );
          },
        );
      }
    });
  }

  bool isFavorite(Series series) => _allFavorites.any((s) => s.id == series.id);

  void loadInitialFavorites() {
    add(LoadSerieFavorites());
  }
}
