import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_app/core/navigation/routes/actors_screen.dart';
import 'package:tv_app/core/navigation/routes/tv_shows_routes.dart';

class AppNavigationService {
  AppNavigationService({
    required this.appRouter,
  });

  final GoRouter appRouter;

  void _routeTo(
    String location,
  ) {
    if (kIsWeb) {
      appRouter.go(location);
    } else {
      appRouter.push(location);
    }
  }

  bool canPop() => appRouter.canPop();

  bool pop() {
    if (canPop()) {
      appRouter.pop(true);
      return true;
    }
    return false;
  }

  void routeToDynamicLocaton({
    required String location,
  }) =>
      appRouter.go(location);

  void routeToTvShows() => _routeTo(
        TvShowsRoutes.tvShowsRoute,
      );

  void routeToSelectedTvShow({
    required String tvShowId,
  }) =>
      _routeTo(
        TvShowsRoutes.selectedTvShowRoute(
          tvShowId: tvShowId,
        ),
      );

  void routeToFavoriteTvShows() => _routeTo(
        TvShowsRoutes.favoriteTvShowsRoute,
      );

  void routeToActors() => _routeTo(
        ActorsRoutes.actorsRoute,
      );
}