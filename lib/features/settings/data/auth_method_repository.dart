import 'package:hive/hive.dart';
import 'package:tv_app/features/settings/domain/enums/auth_method_type_enum.dart';
import 'package:tv_app/features/settings/domain/interfaces/auth_method_repository_inteface.dart';

class AuthMethodRepository extends IAuthMethodRepository {
  AuthMethodRepository({
    required this.hive,
  });

  final HiveInterface hive;

  @override
  Future<List<AuthMethodType>> getAuthMethods() async {
    final Box<dynamic> box = await Hive.openBox('auth_method');

    final String authMethodTypeString = await box.get(
      'auth_method_type',
      defaultValue: [],
    );

    final List<AuthMethodType> authMethodTypes = AuthMethodType.values
        .where(
          (AuthMethodType e) => authMethodTypeString.contains(e.name),
        )
        .toList();

    await box.close();

    return authMethodTypes;
  }

  @override
  Future<void> saveAuthMethod({
    required List<AuthMethodType> authMethodTypes,
  }) async {
    final Box<dynamic> box = await Hive.openBox('auth_method');

    await box.put(
      'auth_method_type',
      authMethodTypes.map((e) => e.name).toList(),
    );

    await box.close();
  }

  @override
  Future<String?> getAuthPin() async {
    final Box<dynamic> box = await Hive.openBox('auth_method');

    final String? authPin = await box.get(
      'auth_pin',
      defaultValue: null,
    );

    await box.close();

    return authPin;
  }

  @override
  Future<void> saveAuthPin({
    required String authPin,
  }) async {
    final Box<dynamic> box = await Hive.openBox('auth_method');

    await box.put(
      'auth_pin',
      authPin,
    );

    await box.close();
  }
}