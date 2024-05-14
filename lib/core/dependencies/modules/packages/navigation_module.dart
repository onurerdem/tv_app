import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:tv_app/core/navigation/services/dialogs_service.dart';
import 'package:tv_app/core/navigation/services/navigation_service.dart';
import 'package:tv_app/core/navigation/services/router_service.dart';

@module
abstract class NavigationModule {
  @lazySingleton
  GoRouter appRouter() => AppRouterService.initializeAppRouter();

  @lazySingleton
  AppNavigationService appNavigationService(GoRouter appRouter) =>
      AppNavigationService(
        appRouter: appRouter,
      );

  @lazySingleton
  AppDialogsService appDialogsService(GoRouter appRouter) => AppDialogsService(
        appRouter: appRouter,
      );
}