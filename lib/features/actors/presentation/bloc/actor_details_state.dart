import 'package:equatable/equatable.dart';
import 'package:tv_app/features/actors/domain/entities/actor.dart';
import 'package:tv_app/features/actors/domain/entities/actor_cast_credit_entity.dart';

abstract class ActorDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActorDetailsInitial extends ActorDetailsState {}

class ActorDetailsLoading extends ActorDetailsState {}

class ActorDetailsLoaded extends ActorDetailsState {
  final Actor actorDetails;
  final List<ActorCastCreditEntity> actorCastCredits;

  ActorDetailsLoaded(this.actorDetails, this.actorCastCredits);

  @override
  List<Object?> get props => [actorDetails];
}

class ActorDetailsError extends ActorDetailsState {
  final String message;

  ActorDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
