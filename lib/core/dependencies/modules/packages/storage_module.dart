import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';

@module
abstract class StorageModule {
  @lazySingleton
  HiveInterface hiveInterface() {
    final HiveInterface hive = Hive;
    hive.init(null);
    return hive;
  }
}