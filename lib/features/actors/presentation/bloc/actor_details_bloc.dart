import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/actors/domain/usecases/get_actor_cast_credits_usecase.dart';
import 'package:tv_app/features/actors/domain/usecases/get_actor_details_usecase.dart';
import 'package:tv_app/features/actors/presentation/bloc/actor_details_event.dart';
import 'package:tv_app/features/actors/presentation/bloc/actor_details_state.dart';

class ActorDetailsBloc extends Bloc<ActorDetailsEvent, ActorDetailsState> {
  final GetActorDetailsUseCase getActorDetails;
  final GetActorCastCreditsUseCase getActorCastCredits;

  ActorDetailsBloc(this.getActorDetails, this.getActorCastCredits)
      : super(ActorDetailsInitial()) {
    on<GetActorDetailsEvent>((event, emit) async {
      emit(ActorDetailsLoading());

      final actorDetailsResult = await getActorDetails(event.actorId);
      final actorCastCreditsResult = await getActorCastCredits(event.actorId);

      actorDetailsResult.fold(
            (failure) => emit(ActorDetailsError("Failed to load actor details.")),
            (actor) {
          actorCastCreditsResult.fold(
                (failure) => emit(ActorDetailsLoaded(actor, [])),
                (credits) => emit(ActorDetailsLoaded(actor, credits)),
          );
        },
      );
    });
  }
}
