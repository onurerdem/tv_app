// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:go_router/go_router.dart' as _i6;
import 'package:hive/hive.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:package_info_plus/package_info_plus.dart' as _i3;
import 'package:tv_app/core/dependencies/modules/features/tv_shows_module.dart'
    as _i16;
import 'package:tv_app/core/dependencies/modules/packages/event_bus_module.dart'
    as _i12;
import 'package:tv_app/core/dependencies/modules/packages/http_client_module.dart'
    as _i15;
import 'package:tv_app/core/dependencies/modules/packages/navigation_module.dart'
    as _i14;
import 'package:tv_app/core/dependencies/modules/packages/package_info_module.dart'
    as _i11;
import 'package:tv_app/core/dependencies/modules/packages/storage_module.dart'
    as _i13;
import 'package:tv_app/core/event_bus/event_bus_service.dart' as _i4;
import 'package:tv_app/core/navigation/services/dialogs_service.dart'
    as _i10;
import 'package:tv_app/core/navigation/services/navigation_service.dart'
    as _i9;
import 'package:tv_app/features/tv_shows/data/repositories/cloud_tv_shows_repository.dart'
    as _i8;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final packageInfoModule = _$PackageInfoModule();
  final eventBusModule = _$EventBusModule();
  final storageModule = _$StorageModule();
  final navigationModule = _$NavigationModule();
  final httpClientModule = _$HttpClientModule();
  final tvShowsModule = _$TvShowsModule();
  await gh.singletonAsync<_i3.PackageInfo>(
    () => packageInfoModule.packageInfo(),
    preResolve: true,
  );
  gh.lazySingleton<_i4.EventBus>(() => eventBusModule.eventBus());
  gh.lazySingleton<_i5.HiveInterface>(() => storageModule.hiveInterface());
  gh.lazySingleton<_i6.GoRouter>(() => navigationModule.appRouter());
  gh.lazySingleton<_i7.Dio>(() => httpClientModule.appRouter());
  gh.lazySingleton<_i8.CloudTvShowsRepository>(
      () => tvShowsModule.cloudTvShowsRepository(gh<_i7.Dio>()));
  gh.lazySingleton<_i9.AppNavigationService>(
      () => navigationModule.appNavigationService(gh<_i6.GoRouter>()));
  gh.lazySingleton<_i10.AppDialogsService>(
      () => navigationModule.appDialogsService(gh<_i6.GoRouter>()));
  return getIt;
}

class _$PackageInfoModule extends _i11.PackageInfoModule {}

class _$EventBusModule extends _i12.EventBusModule {}

class _$StorageModule extends _i13.StorageModule {}

class _$NavigationModule extends _i14.NavigationModule {}

class _$HttpClientModule extends _i15.HttpClientModule {}

class _$TvShowsModule extends _i16.TvShowsModule {}