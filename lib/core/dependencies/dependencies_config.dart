// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:go_router/go_router.dart' as _i8;
import 'package:hive/hive.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:local_auth/local_auth.dart' as _i5;
import 'package:package_info_plus/package_info_plus.dart' as _i4;
import 'package:tv_app/core/dependencies/modules/features/actors_module.dart'
    as _i22;
import 'package:tv_app/core/dependencies/modules/features/authentication_module.dart'
    as _i17;
import 'package:tv_app/core/dependencies/modules/features/settings_module.dart'
    as _i23;
import 'package:tv_app/core/dependencies/modules/features/tv_shows_module.dart'
    as _i21;
import 'package:tv_app/core/dependencies/modules/packages/event_bus_module.dart'
    as _i18;
import 'package:tv_app/core/dependencies/modules/packages/http_client_module.dart'
    as _i19;
import 'package:tv_app/core/dependencies/modules/packages/navigation_module.dart'
    as _i20;
import 'package:tv_app/core/dependencies/modules/packages/package_info_module.dart'
    as _i16;
import 'package:tv_app/core/dependencies/modules/packages/storage_module.dart'
    as _i15;
import 'package:tv_app/core/event_bus/event_bus_service.dart' as _i6;
import 'package:tv_app/core/navigation/services/dialogs_service.dart'
    as _i12;
import 'package:tv_app/core/navigation/services/navigation_service.dart'
    as _i11;
import 'package:tv_app/features/actors/data/data/actors_repository.dart'
    as _i10;
import 'package:tv_app/features/settings/data/auth_method_repository.dart'
    as _i14;
import 'package:tv_app/features/tv_shows/data/repositories/cloud_tv_shows_repository.dart'
    as _i9;
import 'package:tv_app/features/tv_shows/data/repositories/local_tv_shows_repository.dart'
    as _i13;

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
  final storageModule = _$StorageModule();
  final packageInfoModule = _$PackageInfoModule();
  final authenticationModule = _$AuthenticationModule();
  final eventBusModule = _$EventBusModule();
  final httpClientModule = _$HttpClientModule();
  final navigationModule = _$NavigationModule();
  final tvShowsModule = _$TvShowsModule();
  final actorsModule = _$ActorsModule();
  final settingsModule = _$SettingsModule();
  await gh.singletonAsync<_i3.HiveInterface>(
    () => storageModule.hiveInterface(),
    preResolve: true,
  );
  await gh.singletonAsync<_i4.PackageInfo>(
    () => packageInfoModule.packageInfo(),
    preResolve: true,
  );
  gh.lazySingleton<_i5.LocalAuthentication>(
      () => authenticationModule.localAuthentication());
  gh.lazySingleton<_i6.EventBus>(() => eventBusModule.eventBus());
  gh.lazySingleton<_i7.Dio>(() => httpClientModule.appRouter());
  gh.lazySingleton<_i8.GoRouter>(() => navigationModule.appRouter());
  gh.lazySingleton<_i9.CloudTvShowsRepository>(
      () => tvShowsModule.cloudTvShowsRepository(gh<_i7.Dio>()));
  gh.lazySingleton<_i10.ActorsRepository>(
      () => actorsModule.actorsRepository(gh<_i7.Dio>()));
  gh.lazySingleton<_i11.AppNavigationService>(
      () => navigationModule.appNavigationService(gh<_i8.GoRouter>()));
  gh.lazySingleton<_i12.AppDialogsService>(
      () => navigationModule.appDialogsService(gh<_i8.GoRouter>()));
  gh.lazySingleton<_i13.LocalTvShowsRepository>(
      () => tvShowsModule.localTvShowsRepository(gh<_i3.HiveInterface>()));
  gh.lazySingleton<_i14.AuthMethodRepository>(
      () => settingsModule.authMethodRepository(gh<_i3.HiveInterface>()));
  return getIt;
}

class _$StorageModule extends _i15.StorageModule {}

class _$PackageInfoModule extends _i16.PackageInfoModule {}

class _$AuthenticationModule extends _i17.AuthenticationModule {}

class _$EventBusModule extends _i18.EventBusModule {}

class _$HttpClientModule extends _i19.HttpClientModule {}

class _$NavigationModule extends _i20.NavigationModule {}

class _$TvShowsModule extends _i21.TvShowsModule {}

class _$ActorsModule extends _i22.ActorsModule {}

class _$SettingsModule extends _i23.SettingsModule {}