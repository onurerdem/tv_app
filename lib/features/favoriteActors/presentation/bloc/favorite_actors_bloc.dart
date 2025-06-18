import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../actors/domain/entities/actor.dart';
import '../../../actors/domain/usecases/get_actor_details_usecase.dart';
import '../../domain/usecases/add_actor_to_favorites.dart';
import '../../domain/usecases/remove_actor_from_favorites.dart';
import '../../domain/usecases/get_favorite_actors.dart';
import 'favorite_actors_event.dart';
import 'favorite_actors_state.dart';

class FavoriteActorsBloc
    extends Bloc<FavoriteActorsEvent, FavoriteActorsState> {
  final GetFavoriteActors getFavoriteActors;
  final GetActorDetailsUseCase getActorDetails;
  final AddActorToFavorites addActorToFavorites;
  final RemoveActorFromFavorites removeActorFromFavorites;

  List<Actor> _favoriteActors = [];
  List<Actor> _filteredFavoriteActors = [];

  FavoriteActorsBloc(
    this.getFavoriteActors,
    this.getActorDetails,
    this.addActorToFavorites,
    this.removeActorFromFavorites,
  ) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>((event, emit) async {
      if (state is FavoritesLoading) return;

      emit(FavoritesLoading());

      final result = await getFavoriteActors(NoParams());
      await result.fold(
        (failure) async {
          emit(FavoritesError('Failed to load favorites'));
        },
        (favoriteActors) async {
          _favoriteActors = favoriteActors;
          _filteredFavoriteActors = favoriteActors;

          final dummyActor = Actor(
            id: -1,
            fullName: '',
          );

          emit(FavoritesLoaded(_favoriteActors, dummyActor));
        },
      );
    });

    on<SearchFavoriteActors>((event, emit) async {
      if (state is FavoritesLoading) return;

      emit(FavoritesLoading());

      final result = await getFavoriteActors(NoParams());

      result.fold(
        (failure) {
          if (kDebugMode) {
            print("LoadFavoriteActors Error: ${failure.toString()}");
          }
          emit(FavoritesError(
            "Failed to load favorites.",
          ));
        },
        (favoriteActors) {
          _favoriteActors = favoriteActors;

          final dummyActor = Actor(
            id: -1,
            fullName: '',
          );

          final query = event.query.trim().toLowerCase();
          if (query.isEmpty) {
            _filteredFavoriteActors = _favoriteActors;
          } else {
            _filteredFavoriteActors = _favoriteActors.where((actor) {
              return actor.fullName.toLowerCase().contains(query);
            }).toList();
          }

          emit(FavoritesLoaded(_filteredFavoriteActors, dummyActor));

          if (kDebugMode) {
            print("Favorites loaded: $_filteredFavoriteActors");
          }
        },
      );
    });

    on<AddToFavoritesEvent>((event, emit) async {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        if (currentState.favoriteActors.contains(event.actor)) {
          return;
        }

        final updatedFavoriteActors =
            List<Actor>.from(currentState.favoriteActors)..add(event.actor);

        final result = await addActorToFavorites(event.actor);
        result.fold(
          (failure) {
            final revertedFavoriteActors =
                List<Actor>.from(currentState.favoriteActors);

            emit(FavoritesLoaded(revertedFavoriteActors, event.actor));
            emit(FavoritesError("Failed to add to favorites."));
          },
          (_) {
            if (kDebugMode) {
              print("Added to favorites: ${event.actor.id}");
            }
            emit(FavoritesLoaded(updatedFavoriteActors, event.actor));
          },
        );
      }
    });

    on<RemoveFromFavoritesEvent>((event, emit) async {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        if (!currentState.favoriteActors.contains(event.actor)) {
          return;
        }

        final updatedFavoriteActors =
            List<Actor>.from(currentState.favoriteActors)
              ..removeWhere((s) => s.id == event.actor.id);

        final result = await removeActorFromFavorites(event.actor.id);
        result.fold(
          (failure) {
            final revertedFavoriteActors =
                List<Actor>.from(currentState.favoriteActors);
            emit(FavoritesLoaded(revertedFavoriteActors, event.actor));
            emit(FavoritesError("Failed to remove from favorites."));
          },
          (_) {
            emit(FavoritesLoaded(updatedFavoriteActors, event.actor));
          },
        );
      }
    });
  }

  bool isFavorite(int actorId) {
    return _favoriteActors.any((actor) => actor.id == actorId);
  }
}
