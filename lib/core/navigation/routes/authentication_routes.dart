import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_app/features/authentication/presentation/splash_screen.dart';

class AuthenticationRoutes {
  AuthenticationRoutes._();

  static const String splashScreenRoute = '/';

  static List<RouteBase> routes = [
    GoRoute(
      path: splashScreenRoute,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const CupertinoPage(
          child: SplashScreen(),
        );
      },
    ),
  ];
}