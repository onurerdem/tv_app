import 'package:go_router/go_router.dart';
import 'package:tv_app/core/navigation/routes/actors_routes.dart';
import 'package:tv_app/core/navigation/routes/authentication_routes.dart';
import 'package:tv_app/core/navigation/routes/settings_routes.dart';
import 'package:tv_app/core/navigation/routes/tv_shows_routes.dart';

class AppRoutesService {
  AppRoutesService._();

  static List<RouteBase> appRoutes = [
    ...AuthenticationRoutes.routes,
    ...TvShowsRoutes.routes,
    ...ActorsRoutes.routes,
    ...SettingsRoute.routes,
  ];
}