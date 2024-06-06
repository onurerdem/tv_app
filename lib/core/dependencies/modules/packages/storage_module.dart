import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

@module
abstract class StorageModule {
  @preResolve
  @singleton
  Future<HiveInterface> hiveInterface() async {
    final HiveInterface hive = Hive;
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    hive.init(appDocumentDirectory.path);
    return hive;
  }
}