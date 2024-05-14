import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/features/tv_shows/data/repositories/cloud_tv_shows_repository.dart';
import 'package:tv_app/features/tv_shows/data/repositories/local_tv_shows_repository.dart';
import 'package:tv_app/features/tv_shows/presentation/screens/favorite_tv_shows_screen.dart';
import 'package:tv_app/features/tv_shows/presentation/screens/selected_tv_show_screen.dart';
import 'package:tv_app/features/tv_shows/presentation/screens/tv_shows_screen.dart';
import 'package:tv_app/features/tv_shows/state/favorite_tv_shows/favorite_tv_shows_cubit.dart';
import 'package:tv_app/features/tv_shows/state/selected_tv_show/selected_tv_show_cubit.dart';
import 'package:tv_app/features/tv_shows/state/tv_shows/tv_shows_cubit.dart';

class TvShowsRoutes {
  TvShowsRoutes._();

  static const String tvShowsRoute = '/tv-shows';
  static String selectedTvShowRoute({
    required String? tvShowId,
  }) =>
      '/tv-shows/${tvShowId ?? ':tvShowId'}';
  static const String favoriteTvShowsRoute = '/favorite-tv-shows';

  static List<RouteBase> routes = [
    GoRoute(
      path: tvShowsRoute,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return NoTransitionPage<TvShowsCubit>(
          child: BlocProvider(
            create: (BuildContext context) => TvShowsCubit(
              cloudTvShowsRepository: getIt<CloudTvShowsRepository>(),
            )..getTvShows(
                search: null,
              ),
            child: const TvShowsScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: selectedTvShowRoute(tvShowId: null),
      pageBuilder: (BuildContext context, GoRouterState state) {
        final String tvShowId = state.pathParameters['tvShowId']!;

        return NoTransitionPage(
          child: BlocProvider<SelectedTvShowCubit>(
            create: (BuildContext context) => SelectedTvShowCubit(
              cloudTvShowsRepository: getIt<CloudTvShowsRepository>(),
            )..getTvShow(
                tvShowId: tvShowId,
              ),
            child: SelectedTvShowScreen(
              tvShowId: tvShowId,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: favoriteTvShowsRoute,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return NoTransitionPage(
          child: BlocProvider<FavoriteTvShowsCubit>(
            create: (BuildContext context) => FavoriteTvShowsCubit(
              localTvShowsRepository: getIt<LocalTvShowsRepository>(),
            )..getFavoriteTvShows(),
            child: const FavoriteTvShowsScreen(),
          ),
        );
      },
    ),
  ];
}