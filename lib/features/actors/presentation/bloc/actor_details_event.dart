import 'package:equatable/equatable.dart';

abstract class ActorDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetActorDetailsEvent extends ActorDetailsEvent {
  final int actorId;

  GetActorDetailsEvent(this.actorId);

  @override
  List<Object?> get props => [actorId];
}
