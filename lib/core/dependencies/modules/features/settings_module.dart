import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:tv_app/features/settings/data/auth_method_repository.dart';

@module
abstract class SettingsModule {
  @lazySingleton
  AuthMethodRepository authMethodRepository(
    HiveInterface hive,
  ) =>
      AuthMethodRepository(
        hive: hive,
      );
}