import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_app/core/navigation/services/routes_service.dart';

class AppRouterService {
  AppRouterService._();

  static final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  static GoRouter initializeAppRouter() => GoRouter(
        routes: AppRoutesService.appRoutes,
        navigatorKey: mainNavigatorKey,
      );
}