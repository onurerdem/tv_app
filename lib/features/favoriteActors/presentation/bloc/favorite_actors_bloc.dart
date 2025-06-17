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

/*class FavoriteActorsBloc
    extends Bloc<FavoriteActorsEvent, FavoriteActorsState> {
  final GetFavoriteActors getFavoriteActors;
  final AddActorToFavorites addActorToFavorites;
  final RemoveActorFromFavorites removeActorFromFavorites;

  List<Actor> _currentFavorites = [];

  FavoriteActorsBloc(
    this.getFavoriteActors,
    this.addActorToFavorites,
    this.removeActorFromFavorites,
  ) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>((event, emit) async {
      if (state is FavoritesLoading) return;
      emit(FavoritesLoading());
      final result = await getFavoriteActors(NoParams());
      result.fold(
        (failure) {
          if (kDebugMode) {
            print("FavoritesBloc Load Error: ${failure.toString()}");
          }
          emit(FavoritesError("Failed to load favorites."));
        },
        (favoritesList) {
          _currentFavorites = favoritesList;
          emit(FavoritesLoaded(_currentFavorites));
        },
      );
    });

    /*on<AddToFavoritesEvent>((event, emit) async {
      final actor = event.actor;
      if (_currentFavorites.any((a) => a.id == actor.id)) {
        // Zaten varsa, hiçbir şey yapma
        return;
      }
      _currentFavorites.add(actor);
      emit(FavoritesLoaded(List.from(_currentFavorites))); // Optimistic UI

      final result = await addActorToFavorites(actor);
      result.fold(
            (failure) {
          // Hata olursa geri al
          _currentFavorites.removeWhere((a) => a.id == actor.id);
          emit(FavoritesLoaded(List.from(_currentFavorites)));
          if (kDebugMode) {
            print("Error adding to favorites: ${failure.toString()}");
          }
        },
            (_) {
          // Başarılı, UI zaten güncel
        },
      );
    });

    on<RemoveFromFavoritesEvent>((event, emit) async {
      final actorId = event.actorId;
      final prevList = List<Actor>.from(_currentFavorites);
      _currentFavorites.removeWhere((a) => a.id == actorId);
      emit(FavoritesLoaded(List.from(_currentFavorites))); // Optimistic UI

      final result = await removeActorFromFavorites(actorId);
      result.fold(
            (failure) {
          // Hata olursa geri al
          _currentFavorites = prevList;
          emit(FavoritesLoaded(List.from(_currentFavorites)));
          if (kDebugMode) {
            print("Error removing from favorites: ${failure.toString()}");
          }
        },
            (_) {
          // Başarılı
        },
      );
    });*/

    on<AddToFavoritesEvent>((event, emit) async {
      // 1) Önce optimistik olarak listeye ekle
      _currentFavorites.add(event.actor);
      emit(FavoritesLoaded(List.from(_currentFavorites)));

      // 2) Sonra Firestore’a kaydet
      final result = await addActorToFavorites(event.actor);
      result.fold(
        (failure) {
          // Hata olursa geri al
          _currentFavorites.removeWhere((a) => a.id == event.actor.id);
          emit(FavoritesLoaded(List.from(_currentFavorites)));
        },
        (_) {/* Başarılı, UI zaten güncel */},
      );
    });

    on<RemoveFromFavoritesEvent>((event, emit) async {
      // 1) Önce optimistik olarak listeden çıkar
      final removed =
          _currentFavorites.firstWhere((a) => a.id == event.actorId);
      _currentFavorites.removeWhere((a) => a.id == event.actorId);
      emit(FavoritesLoaded(List.from(_currentFavorites)));

      // 2) Sonra Firestore’dan sil
      final result = await removeActorFromFavorites(event.actorId);
      result.fold(
        (failure) {
          // Hata olursa geri al
          _currentFavorites.add(removed);
          emit(FavoritesLoaded(List.from(_currentFavorites)));
        },
        (_) {/* Başarılı */},
      );
    });
  }

  bool isFavorite(int actorId) {
    return _currentFavorites.any((a) => a.id == actorId);
  }
}*/

/*class FavoriteActorsBloc
    extends Bloc<FavoriteActorsEvent, FavoriteActorsState> {
  final GetFavoriteActors getFavorites;
  final AddActorToFavorites addActor;
  final RemoveActorFromFavorites removeActor;
  //List<int> _favoriteIds = [];
  List<Actor> _favoriteActors = [];

  FavoriteActorsBloc(this.getFavorites, this.addActor, this.removeActor)
      : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>((_, emit) async {
      emit(FavoritesLoading());
      final result = await getFavorites(NoParams());
      result.fold(
        (_) => emit(FavoritesError('Failed to load favorites')),
        //(ids) {
        (favoriteActors) {
          /*_favoriteIds = List.from(ids);
          emit(FavoritesLoaded(_favoriteIds));*/
          _favoriteActors = favoriteActors;
          emit(FavoritesLoaded(_favoriteActors));
        },
      );
    });

    on<AddToFavoritesEvent>((event, emit) async {
      /*if (_favoriteIds.contains(event.actor.id)) return;
      _favoriteIds.add(event.actor.id);*/
      if (_favoriteActors.contains(event.actor)) return;
      _favoriteActors.add(event.actor);
      emit(FavoritesLoading()); // önce Loading
      //emit(FavoritesLoaded(_favoriteIds)); // sonra güncel liste
      emit(FavoritesLoaded(_favoriteActors)); // sonra güncel liste
      final result = await addActor(event.actor);
      result.fold(
        (_) {
          //_favoriteIds.remove(event.actor.id);
          _favoriteActors.remove(event.actor);
          emit(FavoritesLoading());
          //emit(FavoritesLoaded(_favoriteIds));
          emit(FavoritesLoaded(_favoriteActors));
        },
        (_) {},
      );
    });

    on<RemoveFromFavoritesEvent>((event, emit) async {
      //if (!_favoriteIds.contains(event.actorId)) return;
      if (!_favoriteActors.contains(_favoriteActors.elementAt(event.actorId))) return;
      //_favoriteIds.remove(event.actorId);
      _favoriteActors.remove(_favoriteActors.elementAt(event.actorId));
      emit(FavoritesLoading());
      //emit(FavoritesLoaded(_favoriteIds));
      emit(FavoritesLoaded(_favoriteActors));
      final result = await removeActor(event.actorId);
      result.fold(
        (_) {
          //_favoriteIds.add(event.actorId);
          _favoriteActors.add(_favoriteActors.elementAt(event.actorId));
          emit(FavoritesLoading());
          emit(FavoritesLoaded(_favoriteActors));
        },
        (_) {},
      );
    });
  }

  bool isFavorite(int id) => _favoriteActors.contains(_favoriteActors.elementAt(id));
}*/

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
      // async eklendi
      if (state is FavoritesLoading) return;

      emit(FavoritesLoading());

      final result = await getFavoriteActors(NoParams());
      await result.fold(
        (failure) async {
          emit(FavoritesError('Failed to load favorites'));
        },
        (favoriteActors) async {
          //_favoriteActors.clear();
          /*for (var id in favoriteActors) {
            final res = await getActorDetails.call(id.id);
            res.fold((_) {}, (actor) {
              _favoriteActors.add(actor);
            });
          }*/
          //_favoriteActors.addAll(favoriteActors);
          _favoriteActors = favoriteActors;
          _filteredFavoriteActors = favoriteActors;

          final dummyActor = Actor(
            id: -1,
            fullName: '',
          );

          //emit(FavoritesLoaded(List.from(_favoriteActors)));
          emit(FavoritesLoaded(_favoriteActors, dummyActor));
        },
      );
    });

    on<SearchFavoriteActors>((event, emit) async {
      if (state is FavoritesLoading) return;

      //emit(SerieFavoritesLoading(favorites: []));
      //emit(SerieFavoritesLoaded([], favorites: []));
      emit(FavoritesLoading());

      /*final query = event.query.trim().toLowerCase();
      if (query.isEmpty) {
        _filteredFavorites = _allFavorites;
      } else {
        _filteredFavorites = _allFavorites.where((serie) {
          return serie.name.toLowerCase().contains(query);
        }).toList();
      }*/

      //final result = await getFavorites(NoParams());
      //final result = await fetchFavoriteSeriesDetails(NoParams());
      final result = await getFavoriteActors(NoParams());

      result.fold(
        (failure) {
          if (kDebugMode) {
            print("LoadFavoriteActors Error: ${failure.toString()}");
          }
          emit(FavoritesError(
            "Failed to load favorites.", /*favorites: []*/
          ));
        },
        (favoriteActors) {
          //_currentFavoriteIds = List.from(favoritesList);
          //emit(FavoritesLoaded(List.from(_currentFavoriteIds)));
          //_currentFavoriteIds.clear();
          //_currentFavoriteIds.addAll(favoritesList);
          //emit(FavoritesLoaded(favoritesList));
          //_currentFavorites = favoritesList;
          //emit(SerieFavoritesLoaded(List.from(_currentFavorites)));
          _favoriteActors = favoriteActors;
          //_filteredFavorites = favoritesList;

          //final favoriteIds = favoriteActors.map((s) => s.id).toList();

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
            //print("FavoritesBloc FavoritesLoaded: $_currentFavoriteIds");
            print("Favorites loaded: $_filteredFavoriteActors");
          }
        },
      );
    });

    on<AddToFavoritesEvent>((event, emit) async {
      /*await addActorToFavorites(event.actor);
      add(LoadFavoritesEvent()); // listeyi yeniden yükle*/

      final currentState = state;
      if (currentState is FavoritesLoaded) {
        if (currentState.favoriteActors.contains(event.actor)) {
          return;
        }

        final updatedFavoriteActors =
            List<Actor>.from(currentState.favoriteActors)..add(event.actor);
        //final updatedIds = updatedFavoriteActors.map((s) => s.id).toList();

        /*emit(SerieFavoritesLoaded(
          updatedIds,
          event.serie,
          allFavorites: updatedFavorites,
          filteredFavorites: updatedFavorites,
        ));*/

        final result = await addActorToFavorites(event.actor);
        result.fold(
          (failure) {
            final revertedFavoriteActors =
                List<Actor>.from(currentState.favoriteActors);

            ///final revertedIds = revertedFavoriteActors.map((s) => s.id).toList();
            emit(FavoritesLoaded(revertedFavoriteActors, event.actor));
            emit(FavoritesError("Failed to add to favorites."));
          },
          (_) {
            if (kDebugMode) {
              print("Added to favorites: ${event.actor.id}");
            }
            //_currentFavorites = updatedFavorites;
            //add(LoadSerieFavorites());
            emit(FavoritesLoaded(updatedFavoriteActors, event.actor));
          },
        );
      }
    });

    on<RemoveFromFavoritesEvent>((event, emit) async {
      /*await removeActorFromFavorites(event.actorId);
      add(LoadFavoritesEvent()); // listeyi yeniden yükle*/

      final currentState = state;
      if (currentState is FavoritesLoaded) {
        if (!currentState.favoriteActors.contains(event.actor)) {
          return;
        }

        final updatedFavoriteActors =
            List<Actor>.from(currentState.favoriteActors)
              ..removeWhere((s) => s.id == event.actor.id);
        //final updatedIds = updatedFavoriteActors.map((s) => s.id).toList();

        /*emit(SerieFavoritesLoaded(
          updatedIds,
          event.serie,
          allFavorites: updatedFavorites,
          filteredFavorites: updatedFavorites,
        ));*/

        final result = await removeActorFromFavorites(event.actor.id);
        result.fold(
          (failure) {
            final revertedFavoriteActors =
                List<Actor>.from(currentState.favoriteActors);
            //final revertedIds = revertedFavorites.map((s) => s.id).toList();
            emit(FavoritesLoaded(revertedFavoriteActors, event.actor));
            emit(FavoritesError("Failed to remove from favorites."));
          },
          (_) {
            //_currentFavorites = updatedFavorites;
            //add(LoadSerieFavorites());
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
