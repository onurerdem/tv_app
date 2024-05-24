import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/actors/data/data/actors_repository.dart';
import 'package:tv_app/features/actors/domain/actor_interface.dart';
import 'package:tv_app/features/actors/state/actors/actors_state.dart';

class ActorsCubit extends Cubit<ActorsState> {
  ActorsCubit({
    required this.actorsRepository,
  }) : super(ActorsLoadingState());

  final ActorsRepository actorsRepository;

  Future<void> getActors({
    required String? search,
  }) async {
    List<IActor> actors = [];
    try {
      emit(ActorsLoadingState());

      if (search != null) {
        actors.addAll(
          await actorsRepository.getActorsWithSearch(
            search: search,
          ),
        );
      } else {
        actors.addAll(
          await actorsRepository.getActors(
            page: 1,
          ),
        );
      }

      emit(
        ActorsLoadedState(
          actors: actors,
          currentPage: 1,
          hasNextPage: search != null ? false : actors.isNotEmpty,
        ),
      );
    } catch (_) {
      emit(ActorsErrorState());
    }
  }

  Future<void> getActorsNextPage() async {
    final ActorsState currentState = state;
    if (currentState is ActorsLoadedState) {
      final List<IActor> newActors = await actorsRepository.getActors(
        page: 1,
      );

      emit(
        ActorsLoadedState(
          actors: currentState.actors..addAll(newActors),
          currentPage: currentState.currentPage + 1,
          hasNextPage: newActors.isNotEmpty,
        ),
      );
    }
  }
}