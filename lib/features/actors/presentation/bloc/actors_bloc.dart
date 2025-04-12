import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/error/failures.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import 'package:tv_app/features/actors/domain/usecases/get_all_actors.dart';
import '../../domain/entities/actor.dart';
import '../../domain/usecases/search_actors.dart';
import 'actors_event.dart';
import 'actors_state.dart';

class ActorsBloc extends Bloc<ActorsEvent, ActorsState> {
  final SearchActors searchActors;
  final GetAllActors getAllActors;

  ActorsBloc(this.searchActors, this.getAllActors) : super(ActorsInitial()) {
    on<GetAllActorsEvent>((event, emit) async {
      emit(ActorsLoading());
      Either<Failure, List<Actor>> result = await getAllActors(NoParams());
      result.fold(
            (failure) => emit(const ActorsError("Failed to load actors.")),
            (actors) => emit(ActorsLoaded(actors)),
      );
    });

    on<SearchActorsQueryEvent>((event, emit) async {
      emit(ActorsLoading());
      if (event.query.isEmpty) {
        add(GetAllActorsEvent());
      } else {
        Either<Failure, List<Actor>> result = await searchActors(event.query);
        result.fold(
              (failure) => emit(const ActorsError("Failed to load actors.")),
              (actors) => emit(ActorsLoaded(actors)),
        );
      }
    });
  }
}
