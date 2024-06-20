import 'package:tv_app/features/settings/domain/enums/auth_method_type_enum.dart';

abstract class IAuthMethodRepository {
  Future<List<AuthMethodType>> getAuthMethods();
  Future<void> saveAuthMethod({
    required List<AuthMethodType> authMethodTypes,
  });
  Future<String?> getAuthPin();
  Future<void> saveAuthPin({
    required String authPin,
  });
}