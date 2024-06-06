import 'package:tv_app/core/event_bus/event_bus_service.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

class FavoriteTvShowAddedEvent extends EventBusMessage {
  FavoriteTvShowAddedEvent({
    required this.tvShow,
  });

  final ITvShow tvShow;
}

class FavoriteTvShowRemovedEvent extends EventBusMessage {
  FavoriteTvShowRemovedEvent({
    required this.tvShowId,
  });

  final String tvShowId;
}